create database Employeedb;
use Employeedb;

create table employee(empno int,eName varchar(20),mgr_no int default null ,hiredate date, sal int,deptno int, primary key(empno),foreign key(deptno) references dept(deptno));

insert into employee values(100,"jack",104,'2006-12-27',100000,6083);
insert into employee values(101,"Nika",104,'2005-11-22',11000,6082);
INSERT INTO employee VALUES(102, "Chris", 103, '2023-08-15', 75000,6081 );
INSERT INTO employee VALUES(103, "Elena", null, '2019-03-01', 125000,6083 );
INSERT INTO employee VALUES(104, "Omar", null, '2024-05-10', 62000,6084);
INSERT INTO employee VALUES (105, "Mia", 109, '2022-07-20', 85000, 6081);
INSERT INTO employee VALUES (106, "Leo", 104, '2023-01-05', 92000, 6083);
INSERT INTO employee VALUES (107, "Sara", 103, '2024-02-28', 78000, 6084);
INSERT INTO employee VALUES (108, "Tom", 109, '2008-09-17', 130000, 6082);
INSERT INTO employee VALUES (109, "Amy", null, '2021-04-12', 95000, 6085);

select * from employee;

create table incentives(empno int,incentive_date date,incentive_amount int, primary key(incentive_date), foreign key(empno) references employee(empno));

insert into incentives values (102,'2009-07-09',18000);
insert into incentives values(103,'2012-12-04',12000);
INSERT INTO incentives VALUES (100, '2025-06-01', 5000);
INSERT INTO incentives VALUES (108, '2025-08-15', 10000);
INSERT INTO incentives VALUES (109, '2025-09-01', 5000);
INSERT INTO incentives VALUES (106, '2025-09-10', 9000);
select * from incentives;

create table dept(deptno int primary key, dname varchar(20), dloc varchar(30));

insert into dept values(6083,"RnD","Hyderabad");
insert into dept values(6081,"PR","bengaluru");
INSERT INTO dept VALUES(6082, "Marketing", "Mysuru");
INSERT INTO dept VALUES(6084, "Finance", "Mumbai");
INSERT INTO dept VALUES(6085, "HR", "Panwel");

select * from dept;

create table project(pno int primary key, ploc varchar(30),pname varchar(30));

insert into project values(33,"Panwel","user privacy");
insert into project values(54,"Hyderabad","bank management");
INSERT INTO project VALUES(78, "Mysuru", "inventory system");
INSERT INTO project VALUES(12, "Hyderabad", "hospital records");
INSERT INTO project VALUES(91, "Bengaluru", "e-commerce site");
INSERT INTO project VALUES(20, "Mumbai", "data visualization");
INSERT INTO project VALUES(45, "Bengaluru", "security audit");

select * from project;

create table assi(empno int,pno int, job_role varchar(30), foreign key(empno) references employee(empno),foreign key(pno) references project(pno));

INSERT INTO assi VALUES(100, 33, 'Lead Developer');
INSERT INTO assi VALUES(101, 54, 'Database Administrator');
INSERT INTO assi VALUES(102, 78, 'Junior Analyst');
INSERT INTO assi VALUES(103, 12, 'Project Manager');
INSERT INTO assi VALUES(104, 91, 'Quality Assurance');
INSERT INTO assi VALUES(105, 20, 'Senior Developer');
INSERT INTO assi VALUES(106, 45, 'Technical Writer');
select * from assi;



SELECT
    M.empno as ManagerName,M.eName AS ManagerName,count(M.empno) as NumberOfEmployees FROM employee E
JOIN
    employee M ON E.mgr_no = M.empno
GROUP BY
    M.eName, M.empno 
ORDER BY
    COUNT(E.empno) DESC ;



		
SELECT
    M.eName AS ManagerName,M.empno as ManagerID,M.sal as ManagerSalary
FROM
    employee E
JOIN
    employee M ON E.mgr_no = M.empno 
GROUP BY
    M.empno, M.eName, M.sal 
HAVING
    M.sal > AVG(E.sal);
    


SELECT DISTINCT
    D.dname AS Department,
    E2.eName AS Second_Level_Manager
FROM
    employee E1         
JOIN
    employee E2 ON E1.empno = E2.mgr_no 
JOIN
    dept D ON E2.deptno = D.deptno 
WHERE
    E1.mgr_no IS NULL;
    

SELECT
    E.eName,
    E.empno,
    E.sal,
    I.incentive_amount
FROM
    incentives I
JOIN
    employee E ON I.empno = E.empno
WHERE
    I.incentive_date >= '2019-01-01' AND I.incentive_date <= '2019-01-31'
ORDER BY
    I.incentive_amount DESC
LIMIT 1 OFFSET 1;



SELECT
    E.eName AS Employee,
    M.eName AS Manager
FROM
    employee E
JOIN
    employee M ON E.mgr_no = M.empno
WHERE
    E.deptno = M.deptno;
    
SELECT DISTINCT
    A.empno
FROM
    assi A
JOIN
    project P ON A.pno = P.pno
WHERE
    P.ploc IN ('Bengaluru', 'Hyderabad', 'Mysuru');


SELECT
    empno
FROM
    employee
WHERE
    empno NOT IN (SELECT empno FROM incentives);
    



SELECT
    E.eName AS EmployeeName,
    E.empno AS EmployeeNumber,
    D.dept_name AS Department,
    A.job_role AS JobRole,
    D.ploc AS DepartmentLocation,
    P.ploc AS ProjectLocation
FROM
    employee E
JOIN
    dept D ON E.deptno = D.deptno
JOIN
    assi A ON E.empno = A.empno   
JOIN
    project P ON A.pno = P.pno   
WHERE
    D.ploc = P.ploc; 




