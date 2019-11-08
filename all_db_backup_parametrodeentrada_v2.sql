-- Script Backup BD
USE master
GO

DROP PROCEDURE IF EXISTS BACKUP_ALL_DB_PARENTRADA
GO

CREATE PROC BACKUP_ALL_DB_PARENTRADA
    @path VARCHAR(256)
AS
    -- Declarando variables
    DECLARE
        @name VARCHAR(50), -- database name
        @fileName VARCHAR(256), -- filename for backup
        @fileDate VARCHAR(20), -- used for file name
        @backupCount INT

    CREATE TABLE [dbo].#tempBackup (
        intID INT IDENTITY (1, 1),
        name VARCHAR(200)
    )

    -- Establecemos o valor para a variable @fileDate como a data en formato YYYYMMDD
    -- SET @fileDate = CONVERT(VARCHAR(20), GETDATE(), 112)

    -- Establecemos o valor para a variable @fileDate como a data en formato YYYYMMDD_hh:mm:ss
     SET @fileDate = CONVERT(VARCHAR(20), GETDATE(), 112) + '_' + REPLACE(CONVERT(VARCHAR(20), GETDATE(), 108), ':', '')

    INSERT INTO [dbo].#tempBackup (name)
        SELECT name
			FROM master.dbo.sysdatabases
			-- seleccionamos hacer un backup de las bd nortwind y pubs si estan en el sql-server
			WHERE name in ( 'Northwind','pubs') 
			-- seleccionamos hacer un backup de todas las bd del sql-server que no sean las especificadas abajo 
			-- WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')

    SELECT @backupCount = count(*)
        FROM [dbo].#tempBackup

    -- mostramos el nro de backups que va a realizar
    print 'Número de BDs a guardar: ' + convert(varchar(50), @backupCount)

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
-- la carpeta del path de entrada 'C:\Backup\' tiene que estar creada en el pc
EXEC BACKUP_ALL_DB_PARENTRADA 'C:\Backup\'
GO

