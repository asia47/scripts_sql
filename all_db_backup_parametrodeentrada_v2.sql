-- Script Backup BD
USE master
GO

DROP PROCEDURE IF EXISTS BACKUP_ALL_DB_PARENTRADA
GO

-- SQL Server 2017
-- CREATE OR ALTER
CREATE PROC BACKUP_ALL_DB_PARENTRADA
    @path VARCHAR(256)
AS
    -- Declarando variables
    DECLARE
        @name VARCHAR(50), -- database name
        -- @path VARCHAR(256), -- path for backup files
        @fileName VARCHAR(256), -- filename for backup
        @fileDate VARCHAR(20), -- used for file name
        @backupCount INT

    CREATE TABLE [dbo].#tempBackup (
        intID INT IDENTITY (1, 1),
        name VARCHAR(200)
    )

    -- Crear la Carpeta Backup
    -- SET @path = 'C:\Backup\'

    -- Includes the date in the filename
    SET @fileDate = CONVERT(VARCHAR(20), GETDATE(), 112)

    -- Includes the date and time in the filename
    --SET @fileDate = CONVERT(VARCHAR(20), GETDATE(), 112) + '_' + REPLACE(CONVERT(VARCHAR(20), GETDATE(), 108), ':', '')

    INSERT INTO [dbo].#tempBackup (name)
        SELECT name
        FROM master.dbo.sysdatabases
        WHERE name in ( 'Northwind','pubs')
    -- WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')

    SELECT @backupCount = count(*)
        FROM [dbo].#tempBackup

    -- Utilidad: Solo Comprobación Nº Backups a realizar
    print 'Número de BDs a guardar: ' + @backupCount

    IF ((@backupCount IS NOT NULL) AND (@backupCount > 0)) BEGIN
        DECLARE @currentBackup INT
        SET @currentBackup = 1
        
        WHILE (@currentBackup <= @backupCount) BEGIN
            SELECT
                    @name = name,
                    @fileName = @path + name + '_' + @fileDate + '.BAK' -- ejemplo: @filename = 'C:\Backup\pubs_20191106.BAK'
                FROM [dbo].#tempBackup
                WHERE intID = @currentBackup
                
            print 'Nombre del archivo a guardar: ' + @fileName

            BACKUP DATABASE @name TO DISK = @fileName -- ejemplo: BACKUP DATABASE 'pubs' TO DISK = 'C:\Backup\pubs_20191106.BAK'
            -- overwrites the existing file (Note: remove @fileDate from the fileName so they are no longer unique
            --BACKUP DATABASE @name TO DISK = @fileName WITH INIT

            SET @currentBackup = @currentBackup + 1
        END
    END

    -- BORRAMOS LA TRABLA TEMPORAL
    DROP TABLE [dbo].#tempBackup
GO

-- Ejecutar Procedimiento
EXEC BACKUP_ALL_DB_PARENTRADA 'C:\Backup\'
GO

