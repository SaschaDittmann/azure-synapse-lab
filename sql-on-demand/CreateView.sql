CREATE VIEW dbo.vw<your prefix>GreenTaxiFiltered
AS
SELECT *
FROM OPENROWSET(
    BULK 'https://<storage account name>.dfs.core.windows.net/nyctlc/<your prefix>/green/*/*/*.parquet',
    FORMAT='PARQUET'
) AS [r]
WHERE YEAR(lpepPickupDateTime) IN (2017,2018,2019);
