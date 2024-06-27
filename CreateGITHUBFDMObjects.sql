CREATE TABLE FDM_Metadata (
    MetadataID INT IDENTITY(1,1) PRIMARY KEY,
    DatasetName NVARCHAR(255),
    Description NVARCHAR(MAX),
    BuildDate DATE,
    DataUpTo DATE,
    ObservationPeriodStart DATE,
    ObservationPeriodEnd DATE,
    TableName NVARCHAR(255),
    TableType NVARCHAR(50),
    AdditionalInfo NVARCHAR(MAX),
    CreatedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE FDM_Tables (
    TableID INT IDENTITY(1,1) PRIMARY KEY,
    MetadataID INT,
    TableName NVARCHAR(255),
    TableType NVARCHAR(50),
    Description NVARCHAR(MAX),
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (MetadataID) REFERENCES FDM_Metadata(MetadataID)
);
