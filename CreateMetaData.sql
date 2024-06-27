-- Drop the temporary table
-- Run this from the database you want to generate the metadata for 
DROP TABLE #TableMetadata;

-- Create a temporary table to store the metadata
CREATE TABLE #TableMetadata (
    TableName NVARCHAR(256),
    ColumnName NVARCHAR(256),
    DataType NVARCHAR(256),
    DistinctValues NVARCHAR(MAX)
);

-- Declare a cursor to iterate over all the columns in the database
DECLARE @TableName NVARCHAR(256);
DECLARE @ColumnName NVARCHAR(256);
DECLARE @DataType NVARCHAR(256);
DECLARE @SQL NVARCHAR(MAX);

DECLARE column_cursor CURSOR FOR
SELECT 
    t.name AS TableName, 
    c.name AS ColumnName,
    tp.name AS DataType
FROM 
    sys.tables t
    INNER JOIN sys.columns c ON t.object_id = c.object_id
    INNER JOIN sys.types tp ON c.user_type_id = tp.user_type_id
WHERE 
    t.type = 'U' -- User tables only
ORDER BY 
    t.name, c.column_id;

-- Open the cursor
OPEN column_cursor;

-- Fetch the next column
FETCH NEXT FROM column_cursor INTO @TableName, @ColumnName, @DataType;

-- Loop through all the columns
WHILE @@FETCH_STATUS = 0
BEGIN
    -- Construct the dynamic SQL to get the most frequently occurring values for the column
    SET @SQL = 'INSERT INTO #TableMetadata (TableName, ColumnName, DataType, DistinctValues)
                SELECT ''' + @TableName + ''', ''' + @ColumnName + ''', ''' + @DataType + ''',
                STUFF((SELECT '', '' + CAST([' + @ColumnName + '] AS NVARCHAR(MAX))
                       FROM (SELECT TOP 3 [' + @ColumnName + ']
                             FROM ' + @TableName + '
                             GROUP BY [' + @ColumnName + ']
                             ORDER BY COUNT(*) DESC) AS t
                       FOR XML PATH('''')), 1, 2, '''')';

    -- Execute the dynamic SQL
    EXEC sp_executesql @SQL;

    -- Fetch the next column
    FETCH NEXT FROM column_cursor INTO @TableName, @ColumnName, @DataType;
END;

-- Close and deallocate the cursor
CLOSE column_cursor;
DEALLOCATE column_cursor;

-- Select the metadata
SELECT * FROM #TableMetadata;


