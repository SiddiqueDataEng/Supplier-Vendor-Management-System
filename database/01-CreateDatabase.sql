/*
 * Supplier Vendor Management System
 * Project #10 - Complete Database Implementation
 * SQL Server 2008/2012
 * Technology: MSSQL, C#
 * Created: 2012
 */

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'VendorDB')
BEGIN
    ALTER DATABASE VendorDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE VendorDB;
END
GO

CREATE DATABASE VendorDB
ON PRIMARY
(
    NAME = 'VendorDB_Data',
    FILENAME = 'C:\SQLData\VendorDB_Data.mdf',
    SIZE = 100MB,
    MAXSIZE = 5GB,
    FILEGROWTH = 10MB
)
LOG ON
(
    NAME = 'VendorDB_Log',
    FILENAME = 'C:\SQLData\VendorDB_Log.ldf',
    SIZE = 50MB,
    MAXSIZE = 1GB,
    FILEGROWTH = 5MB
);
GO

ALTER DATABASE VendorDB SET RECOVERY SIMPLE;
ALTER DATABASE VendorDB SET AUTO_UPDATE_STATISTICS ON;
GO

USE VendorDB;
GO

PRINT 'Database VendorDB created successfully';
PRINT 'Project: Supplier Vendor Management System';
PRINT 'Description: Vendor profiles, contracts, and payment cycles';
GO
