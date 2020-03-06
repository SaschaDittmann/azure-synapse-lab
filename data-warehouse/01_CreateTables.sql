CREATE SCHEMA [prefix];
GO
CREATE TABLE [prefix].[factGreenCab]
(
	[vendorID] [int] NULL,
	[lpepPickupDatetime] [datetime] NULL,
	[lpepDropoffDatetime] [datetime] NULL,
	[passengerCount] [int] NULL,
	[tripDistance] [float] NULL,
	[puLocationId] [varchar](3) NULL,
	[doLocationId] [varchar](3) NULL,
	[pickupLongitude] [float] NULL,
	[pickupLatitude] [float] NULL,
	[dropoffLongitude] [float] NULL,
	[dropoffLatitude] [float] NULL,
	[rateCodeID] [int] NULL,
	[storeAndFwdFlag] [varchar](1) NULL,
	[paymentType] [int] NULL,
	[fareAmount] [float] NULL,
	[extra] [float] NULL,
	[mtaTax] [float] NULL,
	[improvementSurcharge] [varchar](4) NULL,
	[tipAmount] [float] NULL,
	[tollsAmount] [float] NULL,
	[ehailFee] [float] NULL,
	[totalAmount] [float] NULL,
	[tripType] [int] NULL,
	[puYear] [int]  NULL,
	[puMonth] [int]  NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO

CREATE TABLE [prefix].[factYellowCab]
(
	[vendorID] [varchar](3) NULL,
	[tpepPickupDateTime] [datetime] NULL,
	[tpepDropoffDateTime] [datetime] NULL,
	[passengerCount] [int] NULL,
	[tripDistance] [float] NULL,
	[puLocationId] [varchar](3) NULL,
	[doLocationId] [varchar](3) NULL,
	[startLon] [float] NULL,
	[startLat] [float] NULL,
	[endLon] [float] NULL,
	[endLat] [float] NULL,
	[rateCodeId] [int] NULL,
	[storeAndFwdFlag] [varchar](1) NULL,
	[paymentType] [varchar](10) NULL,
	[fareAmount] [float] NULL,
	[extra] [float] NULL,
	[mtaTax] [float] NULL,
	[improvementSurcharge] [varchar](10) NULL,
	[tipAmount] [float] NULL,
	[tollsAmount] [float] NULL,
	[totalAmount] [float] NULL,
	[puYear] [int]  NULL,
	[puMonth] [int]  NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO

CREATE TABLE [prefix].[factholiday]
(
	[countryOrRegion] [varchar](20) NOT NULL,
	[holidayName] [varchar](165) NOT NULL,
	[normalizeHolidayName] [varchar](165) NOT NULL,
	[isPaidTimeOff] [int] NOT NULL,
	[countryRegionCode] [varchar](2) NULL,
	[date] [datetime] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO

CREATE TABLE [prefix].[factweather]
(
	[usaf] [varchar](6) NULL,
	[wban] [varchar](5) NULL,
	[datetime] [datetime] NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[elevation] [float] NULL,
	[windAngle] [int] NULL,
	[windSpeed] [float] NULL,
	[temperature] [float] NULL,
	[seaLvlPressure] [float] NULL,
	[cloudCoverage] [varchar](4) NULL,
	[presentWeatherIndicator] [int] NULL,
	[pastWeatherIndicator] [int] NULL,
	[precipTime] [float] NULL,
	[precipDepth] [float] NULL,
	[snowDepth] [float] NULL,
	[stationName] [varchar](58) NULL,
	[countryOrRegion] [varchar](2) NULL,
    [year] [int] NULL,
	[day] [int] NULL,
    [month] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
CREATE TABLE [prefix].[factFHV]
(
	[dispatchBaseNum] [varchar](40) NULL,
	[pickupDateTime] [datetime] NULL,
	[dropOffDateTime] [datetime] NULL,
	[puLocationId] [varchar](3) NULL,
	[doLocationId] [varchar](3) NULL,
	[srFlag] [varchar](3) NULL,
	[puYear] [int] NULL,
	[puMonth] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO