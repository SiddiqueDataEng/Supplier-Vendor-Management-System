-- SQL Agent Job Setup for Vendor Management
-- SQL Server 2008 R2 / 2012
-- Run this script to create scheduled jobs

USE msdb;
GO

-- Create job category if not exists
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name = 'Data Engineering' AND category_class = 1)
BEGIN
    EXEC msdb.dbo.sp_add_category
        @class = N'JOB',
        @type = N'LOCAL',
        @name = N'Data Engineering';
END
GO

-- Create the job
DECLARE @jobId BINARY(16);
EXEC msdb.dbo.sp_add_job
    @job_name = N'Supplier-Vendor-Management-System_DailyJob',
    @enabled = 1,
    @description = N'Daily processing job for Vendor Management',
    @category_name = N'Data Engineering',
    @job_id = @jobId OUTPUT;

-- Add job step
EXEC msdb.dbo.sp_add_jobstep
    @job_name = N'Supplier-Vendor-Management-System_DailyJob',
    @step_name = N'Execute Daily Processing',
    @subsystem = N'TSQL',
    @command = N'EXEC VendorDB.dbo.usp_DailyProcessing',
    @database_name = N'VendorDB',
    @on_success_action = 1,
    @on_fail_action = 2;

-- Create schedule (Daily at 2:00 AM)
EXEC msdb.dbo.sp_add_schedule
    @schedule_name = N'Supplier-Vendor-Management-System_DailySchedule',
    @enabled = 1,
    @freq_type = 4, -- Daily
    @freq_interval = 1,
    @active_start_time = 020000; -- 2:00 AM

-- Attach schedule to job
EXEC msdb.dbo.sp_attach_schedule
    @job_name = N'Supplier-Vendor-Management-System_DailyJob',
    @schedule_name = N'Supplier-Vendor-Management-System_DailySchedule';

-- Add job to local server
EXEC msdb.dbo.sp_add_jobserver
    @job_name = N'Supplier-Vendor-Management-System_DailyJob',
    @server_name = N'(LOCAL)';

PRINT 'SQL Agent job created successfully';
PRINT 'Job Name: Supplier-Vendor-Management-System_DailyJob';
PRINT 'Schedule: Daily at 2:00 AM';
GO

