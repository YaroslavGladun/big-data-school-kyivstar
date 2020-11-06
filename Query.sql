CREATE USER [parkour] FOR LOGIN [parkour]
WITH DEFAULT_SCHEMA=[parkour_schema] ;

EXEC sp_addrolemember N'db_owner', N'parkour' ;

CREATE DATABASE SCOPED CREDENTIAL YaroslavHladunStorageCredential02
WITH
  IDENTITY = 'storage account',
  SECRET = 'V0Jok1JNtPc7Ni0lDMMljA43iRzzadDXQeyhAnB0rUwIzK3aU96UaFHzC5wMoWiv8GwgFPuX32/cMhphNB9cvA==' ;


CREATE EXTERNAL DATA SOURCE YellowTripdata02
WITH
  ( LOCATION = 'wasbs://hladun@bigdataschoolstr04.blob.core.windows.net/' ,
    CREDENTIAL = YaroslavHladunStorageCredential02,
    TYPE = HADOOP
  ) ;
GO
CREATE EXTERNAL FILE FORMAT CSV05
WITH (FORMAT_TYPE = DELIMITEDTEXT,
      FORMAT_OPTIONS(
          FIELD_TERMINATOR = ',',
          STRING_DELIMITER = '"',
          FIRST_ROW = 2, 
          USE_TYPE_DEFAULT = True)
); 
GO

CREATE EXTERNAL TABLE [parkour_schema].[yellow_trip_external_04]
(
	[VendorID] [int] NULL,
	[tpep_pickup_datetime] [datetime] NULL,
	[tpep_dropoff_datetime] [datetime] NULL,
	[passenger_count] [int] NULL,
	[trip_distance] [real] NULL,
	[RatecodeID] [int] NULL,
	[store_and_fwd_flag] [char](1) NULL,
	[PULocationID] [int] NULL,
	[DOLocationID] [int] NULL,
	[payment_type] [int] NULL,
	[fare_amount] [real] NULL,
	[extra] [real] NULL,
	[mta_tax] [real] NULL,
	[tip_amount] [real] NULL,
	[tolls_amount] [real] NULL,
	[improvement_surcharge] [real] NULL,
	[total_amount] [real] NULL,
	[congestion_surcharge] [real] NULL
)
WITH (
    DATA_SOURCE = [YellowTripdata02],
    LOCATION = N'yellow_tripdata_2020-01.csv',
    FILE_FORMAT = [CSV05],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0) ;
GO

CREATE TABLE [parkour_schema].[fact_tripdata]
WITH
(
	DISTRIBUTION = HASH ( [tpep_pickup_datetime] ),
	CLUSTERED COLUMNSTORE INDEX
)
AS SELECT * FROM [parkour_schema].[yellow_trip_external_04]
GO

CREATE TABLE [parkour_schema].Vendor
(
	id int NULL,
	name varchar(255) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED COLUMNSTORE INDEX
)
GO

CREATE TABLE [parkour_schema].RateCode
(
	ID int NOT NULL,
	Name varchar(50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED COLUMNSTORE INDEX
)
GO

CREATE TABLE [parkour_schema].Payment_type
(
	ID int NOT NULL,
	Name varchar(50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED COLUMNSTORE INDEX
)
GO


-- DROP TABLE [parkour_schema].Vendor;

SELECT TOP(5) * FROM [parkour_schema].Vendor;
