CREATE LOGIN [DOMBD\asia47]
	FROM WINDOWS
	WITH DEFAULT_DATABASE=master
go
CREATE LOGIN [DOMBD\Administrador]
	FROM WINDOWS
	WITH DEFAULT_DATABASE=master
go
CREATE LOGIN [DOMBD\clientedb]
	FROM WINDOWS
	WITH DEFAULT_DATABASE=master
go

-- se puede hacer graficamente
/*ALTER SERVER ROLE [sysadmin]
	ADD MEMBER [DOMDB\asia47]
go
ALTER SERVER ROLE [sysadmin]
	ADD MEMBER [DOMDB\Administrador]
go
ALTER SERVER ROLE [sysadmin]
	ADD MEMBER [DOMDB\clientedb]
go*/
