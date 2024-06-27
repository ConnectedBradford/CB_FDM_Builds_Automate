-- Insert metadata for the dataset
INSERT INTO FDM_Metadata (DatasetName, Description, BuildDate, DataUpTo, ObservationPeriodStart, ObservationPeriodEnd, AdditionalInfo)
VALUES ('Connected Bradford Primary Care', 'Contains scripts and documentation for Primary Care dataset with approximately 1 million patients.', '2024-02-08', '2024-02-08', '1900-01-01', '2024-02-08', 'No identifiable information available.');

-- Get the ID of the inserted metadata
DECLARE @MetadataID INT = SCOPE_IDENTITY();

-- Insert tables related to the dataset
INSERT INTO FDM_Tables (MetadataID, TableName, TableType, Description)
VALUES 
(@MetadataID, 'tbl_Admin_LoadLog', 'tbl_', 'Admin Load Log table.'),
(@MetadataID, 'tbl_SRAppointment', 'tbl_', 'SR Appointment table.'),
(@MetadataID, 'tbl_SRCHSStatusHistory', 'tbl_', 'SR CHS Status History table.'),
(@MetadataID, 'tbl_SRCode', 'tbl_', 'SR Code table.'),
(@MetadataID, 'tbl_SRCodeTemplateLink', 'tbl_', 'SR Code Template Link table.'),
(@MetadataID, 'tbl_SRConfiguredListOption', 'tbl_', 'SR Configured List Option table.'),
(@MetadataID, 'tbl_SRDrugSensitivity', 'tbl_', 'SR Drug Sensitivity table.'),
(@MetadataID, 'tbl_SREvent', 'tbl_', 'SR Event table.'),
-- Add all other tables similarly
(@MetadataID, 'tbl_SRVisit', 'tbl_', 'SR Visit table.');
