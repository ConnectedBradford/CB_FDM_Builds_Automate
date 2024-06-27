ALTER PROCEDURE [dbo].[FDM_GITHUB_METADATA_BUILD]
    @DatasetName nvarchar(128),
    @DatasetNameDesc nvarchar(max),
    @Description nvarchar(max),
    @BuildDate nvarchar(100), -- Assuming datetime is passed as string
    @DataUpTo nvarchar(100),  -- Assuming datetime is passed as string
    @ObservationPeriodStart nvarchar(100), -- Assuming datetime is passed as string
    @ObservationPeriodEnd nvarchar(100), -- Assuming datetime is passed as string
    @AdditionalInfo nvarchar(max)
AS
BEGIN
    DECLARE @RealBuildDate datetime;
    DECLARE @RealDataUpTo datetime;
    DECLARE @RealObservationPeriodStart datetime;
    DECLARE @RealObservationPeriodEnd datetime;

    -- Convert strings to datetime
    SET @RealBuildDate = CONVERT(datetime, @BuildDate, 120); -- Adjust format code if needed
    SET @RealDataUpTo = CONVERT(datetime, @DataUpTo, 120); -- Adjust format code if needed
    SET @RealObservationPeriodStart = CONVERT(datetime, @ObservationPeriodStart, 120); -- Adjust format code if needed
    SET @RealObservationPeriodEnd = CONVERT(datetime, @ObservationPeriodEnd, 120); -- Adjust format code if needed

    -- Insert metadata for the dataset
    INSERT INTO CB_FDM_OBJECTS.dbo.FDM_Metadata (DatasetName, Description, BuildDate, DataUpTo, ObservationPeriodStart, ObservationPeriodEnd, AdditionalInfo)
    VALUES (@DatasetName, @Description, @RealBuildDate, @RealDataUpTo, @RealObservationPeriodStart, @RealObservationPeriodEnd, @AdditionalInfo);

    -- Get the ID of the inserted metadata
    DECLARE @MetadataID INT = SCOPE_IDENTITY();

    -- Declare variables for dynamic SQL
    DECLARE @SQL NVARCHAR(MAX);

    -- Construct the dynamic SQL to insert table metadata
    SET @SQL = N'
    INSERT INTO CB_FDM_OBJECTS.dbo.FDM_Tables (MetadataID, TableName, TableType, Description)
    SELECT ' + CAST(@MetadataID AS NVARCHAR) + ', 
           t.name AS TableName,
           CASE WHEN CHARINDEX(''_'', t.name) > 0 THEN LEFT(t.name, CHARINDEX(''_'', t.name) - 1)
                ELSE t.name END AS TableType,
           ''Description for table '' + QUOTENAME(t.name) AS Description
    FROM sys.tables t
    WHERE t.name LIKE ''%_%'' -- Ensure table names contain an underscore
    ORDER BY t.name;';

    -- Print the generated SQL for debugging
    PRINT @SQL;

    -- Execute the generated SQL
    EXEC sp_executesql @SQL;
END
GO
