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

CREATE EXTERNAL FILE FORMAT csv03  
WITH (  
    FORMAT_TYPE = DELIMITEDTEXT,  
    FORMAT_OPTIONS (  
        FIELD_TERMINATOR = N',',
		USE_TYPE_DEFAULT = False),  
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.GzipCodec'
);  


CREATE EXTERNAL TABLE [parkour_schema].[yellow_trip_external_03]
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
    FILE_FORMAT = [csv03],
    REJECT_TYPE = VALUE,
    REJECT_VALUE = 0)
GO


-- Drop a table called 'TableName' in schema 'dbo'
-- Drop the table if it already exists
IF OBJECT_ID('[parkour_schema].[yellow_trip_external_03]', 'U') IS NOT NULL
DROP TABLE [parkour_schema].[yellow_trip_external_03]
GO
