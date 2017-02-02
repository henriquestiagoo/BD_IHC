
use master;

--DROP TABLE mytemp;

CREATE TABLE mytemp (
	rid BIGINT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
	at1 INT NULL,
	at2 INT NULL,
	at3 INT NULL,
	lixo varchar(100) NULL
);

--SET IDENTITY_INSERT mytemp ON;

-- Record the Start Time
DECLARE @start_time DATETIME, @end_time DATETIME;
SET @start_time = GETDATE();
PRINT @start_time

-- Generate random records
DECLARE @val as int = 1;
DECLARE @nelem as int = 50000;

SET nocount ON
WHILE @val <= @nelem
BEGIN
	DBCC DROPCLEANBUFFERS; -- need to be sysadmin
	INSERT mytemp (rid, at1, at2, at3, lixo)
	SELECT cast((RAND()*@nelem*40000) as int), cast((RAND()*@nelem) as int),
		cast((RAND()*@nelem) as int), cast((RAND()*@nelem) as int),
			'lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo';
	SET @val = @val + 1;
	Print @val;
END

PRINT 'Inserted ' + str(@nelem) + ' total records'

-- Duration of Insertion Process
SET @end_time = GETDATE();
PRINT 'Milliseconds used: ' + CONVERT(VARCHAR(20), DATEDIFF(MILLISECOND, @start_time, @end_time));

--ex2b
SELECT * FROM sys.dm_db_index_physical_stats ( db_id('master'), OBJECT_ID('Frag'), NULL, NULL, 'DETAILED');

/*
-- ex2c
ALTER INDEX ALL ON mytemp REBUILD WITH (FILLFACTOR = 65) 
--ALTER INDEX ALL ON mytemp REBUILD WITH (FILLFACTOR = 80)
--ALTER INDEX ALL ON mytemp REBUILD WITH (FILLFACTOR = 90)

--ex2d
--mudanca na tabela

-- ex2e
CREATE INDEX IxAt1 ON mytemp(at1)
CREATE INDEX IXAt2 ON mytemp(at2);
CREATE INDEX IXAt3 ON mytemp(at3);
CREATE INDEX IXLixo ON mytemp(lixo);
*/


