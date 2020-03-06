CREATE PROCEDURE [prefix].[CleanupStagingTables]
AS
truncate TABLE [prefix].[factGreenCab];
truncate TABLE [prefix].[factYellowCab];
truncate TABLE [prefix].[factholiday];
truncate TABLE [prefix].[factweather];
truncate TABLE [prefix].[factFHV];
GO
