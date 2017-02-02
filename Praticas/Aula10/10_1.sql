
use AdventureWorks2012;

DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;

--ex1
SELECT * FROM Production.WorkOrder;

--ex2
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
select * from Production.WorkOrder where WorkOrderID=1234 

--ex3
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
SELECT * FROM Production.WorkOrder   WHERE WorkOrderID between 10000 and 10010;
SELECT * FROM Production.WorkOrder   WHERE WorkOrderID between 1 and 72591;

--ex4
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
SELECT * FROM Production.WorkOrder  WHERE StartDate = '2007-06-25' 

--ex5
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
SELECT * FROM Production.WorkOrder WHERE ProductID = 757;

--ex6
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
--DROP INDEX IxWorkOrderProductID ON Production.WorkOrder;
CREATE INDEX IxWorkOrderProductID ON Production.WorkOrder (ProductID)
INCLUDE (StartDate)

--SELECT WorkOrderID, StartDate FROM Production.WorkOrder   WHERE ProductID = 757; 
--SELECT WorkOrderID, StartDate FROM Production.WorkOrder   WHERE ProductID = 945;
SELECT WorkOrderID FROM Production.WorkOrder   WHERE ProductID = 945 AND StartDate = '2006-01-04';

--ex7
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
--DROP INDEX IxWorkOrderProductID ON Production.WorkOrder;
--DROP INDEX IxWorkOrderStartDate ON Production.WorkOrder;
CREATE INDEX IxWorkOrderProductID ON Production.WorkOrder (ProductID)
CREATE INDEX IxWorkOrderStartDate ON Production.WorkOrder (StartDate)
SELECT WorkOrderID, StartDate FROM Production.WorkOrder   WHERE ProductID = 945 AND StartDate = '2006-01-04' 

--ex8
DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
--DROP INDEX IxWorkOrderProductIDStartDate ON Production.WorkOrder;
CREATE INDEX IxWorkOrderProductIDStartDate ON Production.WorkOrder (ProductID,StartDate)
SELECT WorkOrderID, StartDate FROM Production.WorkOrder   WHERE ProductID = 945 AND StartDate = '2006-01-04'