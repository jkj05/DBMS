create database supplierdb;
use supplierdb;

CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(255),
    city VARCHAR(100)
);

CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(255),
    color VARCHAR(50)
);

CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost DECIMAL(10, 2),
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid) ON DELETE CASCADE,
    FOREIGN KEY (pid) REFERENCES Parts(pid) ON DELETE CASCADE
);

INSERT INTO Supplier (sid, sname, city) VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');

INSERT INTO Parts (pid, pname, color) VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');

INSERT INTO Catalog (sid, pid, cost) VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);

SELECT P.pname
FROM Parts P
WHERE P.pid IN (SELECT C.pid FROM Catalog C);

SELECT S.sname
FROM Supplier S
JOIN Catalog C ON S.sid = C.sid
GROUP BY S.sid, S.sname
HAVING COUNT(DISTINCT C.pid) = (SELECT COUNT(*) FROM Parts);

SELECT S.sname
FROM Supplier S
JOIN Catalog C ON S.sid = C.sid
JOIN Parts P ON C.pid = P.pid
WHERE P.color = 'Red'
GROUP BY S.sid, S.sname
HAVING COUNT(DISTINCT P.pid) = (SELECT COUNT(*) FROM Parts WHERE color = 'Red');

SELECT P.pname
FROM Parts P
WHERE P.pid IN (
    
    SELECT C.pid 
    FROM Catalog C 
    JOIN Supplier S ON C.sid = S.sid 
    WHERE S.sname = 'Acme Widget'
)
AND P.pid NOT IN (
    
    SELECT C.pid 
    FROM Catalog C 
    JOIN Supplier S ON C.sid = S.sid 
    WHERE S.sname != 'Acme Widget'
);

SELECT DISTINCT C.sid
FROM Catalog C
JOIN (
   
    SELECT pid, AVG(cost) AS avg_cost
    FROM Catalog
    GROUP BY pid
) AS AvgParts ON C.pid = AvgParts.pid
WHERE C.cost > AvgParts.avg_cost;


SELECT P.pname, S.sname
FROM Catalog C
JOIN Supplier S ON C.sid = S.sid
JOIN Parts P ON C.pid = P.pid
JOIN (
    
    SELECT pid, MAX(cost) AS max_cost
    FROM Catalog
    GROUP BY pid
) AS MaxCosts ON C.pid = MaxCosts.pid AND C.cost = MaxCosts.max_cost
ORDER BY P.pname;


SELECT S.sname, P.pname, C.cost
FROM Catalog C
JOIN Supplier S ON C.sid = S.sid
JOIN Parts P ON C.pid = P.pid
ORDER BY C.cost DESC
LIMIT 1;

SELECT S.sname
FROM Supplier S
WHERE S.sid NOT IN (
    
    SELECT DISTINCT C.sid
    FROM Catalog C
    JOIN Parts P ON C.pid = P.pid
    WHERE P.color = 'Red'
);

SELECT S.sname, COALESCE(SUM(C.cost), 0) AS total_value
FROM Supplier S
LEFT JOIN Catalog C ON S.sid = C.sid
GROUP BY S.sid, S.sname;

SELECT S.sname
FROM Supplier S
JOIN Catalog C ON S.sid = C.sid
WHERE C.cost < 20
GROUP BY S.sid, S.sname
HAVING COUNT(C.pid) >= 2;

SELECT P.pname, S.sname, C.cost
FROM Catalog C
JOIN Supplier S ON C.sid = S.sid
JOIN Parts P ON C.pid = P.pid
JOIN (
    
    SELECT pid, MIN(cost) AS min_cost
    FROM Catalog
    GROUP BY pid
) AS MinCosts ON C.pid = MinCosts.pid AND C.cost = MinCosts.min_cost
ORDER BY P.pname;

CREATE VIEW SupplierPartCount AS
SELECT S.sname, COUNT(C.pid) AS total_parts_supplied
FROM Supplier S
LEFT JOIN Catalog C ON S.sid = C.sid
GROUP BY S.sid, S.sname;

SELECT * FROM SupplierPartCount;

CREATE VIEW MostExpensiveSupplier AS
SELECT P.pname, S.sname AS most_expensive_supplier, C.cost
FROM Catalog C
JOIN Supplier S ON C.sid = S.sid
JOIN Parts P ON C.pid = P.pid
JOIN (

    SELECT pid, MAX(cost) AS max_cost
    FROM Catalog
    GROUP BY pid
) AS MaxCosts ON C.pid = MaxCosts.pid AND C.cost = MaxCosts.max_cost;

SELECT * FROM MostExpensiveSupplier;


DELIMITER $$	

CREATE TRIGGER trg_check_cost_before_insert
BEFORE INSERT ON Catalog
FOR EACH ROW
BEGIN
    IF NEW.cost < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Cost cannot be less than 1.';
    END IF;
END$$


DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_default_cost_before_insert
BEFORE INSERT ON Catalog
FOR EACH ROW
BEGIN
    IF NEW.cost IS NULL THEN
        SET NEW.cost = 10.00;
    END IF;
END$$

DELIMITER ;






