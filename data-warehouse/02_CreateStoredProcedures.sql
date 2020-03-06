CREATE PROCEDURE [prefix].PopulateDimDate (@Year INT)
AS
BEGIN
--DECLARE @Year INT
--SET @Year = 2019
--drop table #month
       IF OBJECT_ID('tempdb..#month', 'U') IS NOT NULL DROP TABLE #month;
       CREATE TABLE #month (monthnum int, numofdays int) WITH (distribution = round_robin, heap);
       
       INSERT INTO #month
       select 1, 31 union SELECT 2, CASE WHEN (@YEAR % 4 = 0 AND @YEAR % 100 <> 0) OR @YEAR % 400 = 0 THEN 29 ELSE 28 END
       union select 3,31 union select 4,30 union select 5,31 union select 6,30 
       union select 7,31 union select 8,31 union select 9,30 union select 10,31 union select 11,30 union select 12,31;

       --drop table #days
       IF OBJECT_ID('tempdb..#days', 'U') IS NOT NULL DROP TABLE #days;
       CREATE TABLE #days (days int) WITH (distribution = round_robin, heap);

       INSERT INTO #days
       select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9 union select 10
       union select 11 union select 12 union select 13 union select 14 union select 15 union select 16 union select 17 union select 18 union select 19 union select 20
       union select 21 union select 22 union select 23 union select 24 union select 25 union select 26 union select 27 union select 28 union select 29 union select 30 union select 31

       IF OBJECT_ID('prefix.dimdate') IS NULL
       BEGIN
              CREATE TABLE [prefix].[dimDate]
              (
                     [DateKey] [date] NULL,
                     [DateIntKey] [varchar](8) NULL,
                     [DayNumber] [int] NULL,
                     [DayOfWeek] [nvarchar](10) NULL,
                     [MonthName] [nvarchar](10) NULL,
                     [MonthAbbrev] [nvarchar](3) NULL,
                     [MonthNumber] [int] NULL,
                     [CalendarYearMonth] [nvarchar](10) NULL,
                     [CalendarYear] [int] NULL,
                     [CalendarYearLabel] [nvarchar](10) NULL,
                     [FiscalMonthNumber] [int] NULL,
                     [FiscalYearMonth] [nvarchar](20) NULL,
                     [FiscalYear] [int] NULL,
                     [FiscalYearLabel] [nvarchar](10) NULL
              )
              WITH
              (
                     DISTRIBUTION = ROUND_ROBIN,
                     CLUSTERED COLUMNSTORE INDEX
              )
       END
       
       DELETE FROM prefix.dimDate WHERE CalendarYear = @YEAR

    INSERT prefix.dimDate
        ([DateKey], [DateIntKey], [DayNumber], [DayOfWeek], [MonthName], [MonthAbbrev], [MonthNumber], 
            [CalendarYearMonth], [CalendarYear], [CalendarYearLabel],
            [FiscalMonthNumber], [FiscalYearMonth], [FiscalYear], [FiscalYearLabel])
       SELECT CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE) AS [DateKey]
              ,CAST(@year as varchar(4)) + RIGHT('0' + CAST(monthnum as varchar(2)),2) + RIGHT('0' + CAST([days] as VARchar(2)),2) AS [DateIntKey]
              ,DAY(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) AS [DayNumber]
              ,CAST(DATENAME(day, CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) AS nvarchar(10)) AS [DayOfWeek]
              ,CAST(DATENAME(month, CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) AS nvarchar(10)) AS [MonthName]
              ,CAST(SUBSTRING(DATENAME(month, CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)), 1, 3) AS nvarchar(3)) AS [MonthAbbrev]
              ,MONTH(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) AS [MonthNumber]
              ,CAST(N'CY' + CAST(YEAR(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) AS nvarchar(4)) + N'-' + SUBSTRING(DATENAME(month, CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)), 1, 3) AS nvarchar(10)) AS [CalendarYearMonth]
              ,YEAR(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) AS [CalendarYear]
              ,CAST(N'CY' + CAST(YEAR(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) AS nvarchar(4)) AS nvarchar(10)) AS [CalendarYearLabel]
              ,CASE WHEN MONTH(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) IN (11, 12)
                     THEN MONTH(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) - 10
                     ELSE MONTH(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) + 2
              END AS [FiscalMonthNumber]
              ,CAST(N'FY' + CAST(CASE WHEN MONTH(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) IN (11, 12)
                     THEN YEAR(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) + 1
                     ELSE YEAR(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE))
              END AS nvarchar(4)) + N'-' + SUBSTRING(DATENAME(month, CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)), 1, 3) AS nvarchar(20)) AS [FiscalYearMonth]
              ,CASE WHEN MONTH(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) IN (11, 12)
                     THEN YEAR(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) + 1
                     ELSE YEAR(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE))
              END AS [FiscalYear]
              ,CAST(N'FY' + CAST(CASE WHEN MONTH(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) IN (11, 12)
                     THEN YEAR(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE)) + 1
                     ELSE YEAR(CAST(CAST(monthnum as varchar(2)) + '/' + CAST([days] as varchar(3)) + '/' + CAST(@year as char(4)) AS DATE))
              END AS nvarchar(4)) AS nvarchar(10)) AS [FiscalYearLabel]
       FROM #month m
              CROSS JOIN #days d
       WHERE d.days <= m.numofdays

       DROP table #month;
       DROP table #days;
END
GO
CREATE PROC [prefix].[LoadDataHoliday] AS
BEGIN
       IF OBJECT_ID('prefix.HolidayFinal') IS NULL
              CREATE TABLE prefix.HolidayFinal
              WITH (DISTRIBUTION = REPLICATE, CLUSTERED COLUMNSTORE INDEX)
              AS
              SELECT 
                     --ADDING HOLIDAYDATE FOR JOINS
                     CAST([date] as DATE) as HolidayDateKey
                     , *
              FROM prefix.factHoliday
              WHERE countryRegionCode = 'US'  --ONLY US HOLIDAYS FOR NYC CAB DATA
        ELSE
                INSERT INTO prefix.HolidayFinal
                SELECT CAST([date] as DATE) as HolidayDateKey, * from prefix.factHoliday WHERE countryRegionCode = 'US'  --ONLY US HOLIDAYS FOR NYC CAB DATA
END
GO
CREATE PROC [prefix].[LoadDataWeather] AS
BEGIN
       IF OBJECT_ID('prefix.WeatherFinal') IS NULL
              CREATE TABLE prefix.WeatherFinal
              WITH (DISTRIBUTION = ROUND_ROBIN, CLUSTERED COLUMNSTORE INDEX)
              AS
              SELECT CAST([datetime] as DATE) as WeatherDateKey,* from prefix.factweather
        ELSE
                INSERT INTO prefix.WeatherFinal
                SELECT CAST([datetime] as DATE) as WeatherDateKey,* from prefix.factweather
END
GO
CREATE PROC [prefix].[LoadDataGreenCab] AS
BEGIN
       IF OBJECT_ID('prefix.GreenCabFinal') IS NULL
              CREATE TABLE prefix.GreenCabFinal
              WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)
              AS
              SELECT
                     vendorID
                     , lpepPickupDateTime
                     , lpepDropoffDateTime
                     , passengerCount
                     , tripDistance
                     , puLocationId
                     , doLocationId
                     , pickupLongitude
                     , pickupLatitude
                     , dropoffLongitude
                     , dropoffLatitude
                     , rateCodeId
                     , storeAndFwdFlag
                     , paymentType
                     , fareAmount
                     , extra
                     , mtaTax
                     , improvementSurcharge
                     , tipAmount
                     , tollsAmount
                     , totalAmount
                     , puYear
                     , puMonth
                     --ADDED THESE 4 FIELDS THROUGH TRANSFORMS
                     , CAST(lpepPickupDateTime AS DATE) as PickupDate
                     , CAST(lpepPickupDateTime AS TIME) as PickupTime
                     , CAST(lpepDropoffDateTime AS DATE) as DropoffDate
                     , CAST(lpepDropoffDateTime AS TIME) as DropoffTime
              FROM prefix.factGreenCab
        ELSE
                INSERT INTO prefix.GreenCabFinal
                SELECT
                     vendorID
                     , lpepPickupDateTime
                     , lpepDropoffDateTime
                     , passengerCount
                     , tripDistance
                     , puLocationId
                     , doLocationId
                     , pickupLongitude
                     , pickupLatitude
                     , dropoffLongitude
                     , dropoffLatitude
                     , rateCodeId
                     , storeAndFwdFlag
                     , paymentType
                     , fareAmount
                     , extra
                     , mtaTax
                     , improvementSurcharge
                     , tipAmount
                     , tollsAmount
                     , totalAmount
                     , puYear
                     , puMonth
                     --ADDED THESE 4 FIELDS THROUGH TRANSFORMS
                     , CAST(lpepPickupDateTime AS DATE) as PickupDate
                     , CAST(lpepPickupDateTime AS TIME) as PickupTime
                     , CAST(lpepDropoffDateTime AS DATE) as DropoffDate
                     , CAST(lpepDropoffDateTime AS TIME) as DropoffTime
              FROM prefix.factGreenCab
END
GO
CREATE PROC [prefix].[LoadDataYellowCab] AS
BEGIN
       IF OBJECT_ID('prefix.YellowCabFinal') IS NULL
              CREATE TABLE prefix.YellowCabFinal
              WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)
              AS
              SELECT
                     vendorID
                     , tpepPickupDateTime
                     , tpepDropoffDateTime
                     , passengerCount
                     , tripDistance
                     , puLocationId
                     , doLocationId
                     , startLon
                     , startLat
                     , endLon
                     , endLat
                     , rateCodeId
                     , storeAndFwdFlag
                     , paymentType
                     , fareAmount
                     , extra
                     , mtaTax
                     , improvementSurcharge
                     , tipAmount
                     , tollsAmount
                     , totalAmount
                     , puYear
                     , puMonth
                     --ADDED THESE 4 FIELDS THROUGH TRANSFORMS
                     , CAST(tpepPickupDateTime AS DATE) as PickupDate
                     , CAST(tpepPickupDateTime AS TIME) as PickupTime
                     , CAST(tpepDropoffDateTime AS DATE) as DropoffDate
                     , CAST(tpepDropOffDateTime AS TIME) as DropoffTime
              FROM prefix.factYellowCab
        ELSE
                INSERT INTO prefix.YellowCabFinal
                SELECT
                     vendorID
                     , tpepPickupDateTime
                     , tpepDropoffDateTime
                     , passengerCount
                     , tripDistance
                     , puLocationId
                     , doLocationId
                     , startLon
                     , startLat
                     , endLon
                     , endLat
                     , rateCodeId
                     , storeAndFwdFlag
                     , paymentType
                     , fareAmount
                     , extra
                     , mtaTax
                     , improvementSurcharge
                     , tipAmount
                     , tollsAmount
                     , totalAmount
                     , puYear
                     , puMonth
                     --ADDED THESE 4 FIELDS THROUGH TRANSFORMS
                     , CAST(tpepPickupDateTime AS DATE) as PickupDate
                     , CAST(tpepPickupDateTime AS TIME) as PickupTime
                     , CAST(tpepDropoffDateTime AS DATE) as DropoffDate
                     , CAST(tpepDropOffDateTime AS TIME) as DropoffTime
              FROM prefix.factYellowCab
END
GO
CREATE PROC [prefix].[LoadDataFhv] AS
BEGIN
       IF OBJECT_ID('prefix.FhvFinal') IS NULL
              CREATE TABLE prefix.FhvFinal
              WITH (CLUSTERED COLUMNSTORE INDEX, DISTRIBUTION = ROUND_ROBIN)
              AS
              SELECT
                     dispatchBaseNum
                     , pickupDateTime
                     , dropOffDateTime
                     , puLocationId
                     , doLocationId
                     , srFlag
                     , puYear
                     , puMonth
                     --ADDED THESE 4 FIELDS THROUGH TRANSFORMS
                     , CAST(pickupDateTime AS DATE) as PickupDate
                     , CAST(pickupDateTime AS TIME) as PickupTime
                     , CAST(dropOffDateTime AS DATE) as DropoffDate
                     , CAST(dropOffDateTime AS TIME) as DropoffTime
              FROM prefix.factFhv
        ELSE
                INSERT INTO prefix.FhvFinal SELECT
                     dispatchBaseNum
                     , pickupDateTime
                     , dropOffDateTime
                     , puLocationId
                     , doLocationId
                     , srFlag
                     , puYear
                     , puMonth
                     --ADDED THESE 4 FIELDS THROUGH TRANSFORMS
                     , CAST(pickupDateTime AS DATE) as PickupDate
                     , CAST(pickupDateTime AS TIME) as PickupTime
                     , CAST(dropOffDateTime AS DATE) as DropoffDate
                     , CAST(dropOffDateTime AS TIME) as DropoffTime
              FROM prefix.factFhv
END
GO
