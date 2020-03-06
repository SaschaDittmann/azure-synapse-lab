SELECT TOP 100 PERCENT
  	YEAR(tpepPickupDateTime) AS [Year],
  	passengerCount,
  	COUNT(*) AS cnt
FROM  
   OPENROWSET(
  	BULK 'https://<storage account name>.dfs.core.windows.net/nyctlc/yellow/puYear=2017/*/*', 
  	FORMAT='PARQUET'
   ) WITH (
  	tpepPickupDateTime DATETIME2, 
  	passengerCount INT
   ) AS nyc
GROUP BY 
   passengerCount,
   YEAR(tpepPickupDateTime)
ORDER BY
   passengerCount