create database jkj_bank;
use jkj_bank;

create table jkj_bank.branch(
Branch_name varchar(30),
Branch_city varchar(25),
assets int,
PRIMARY KEY (Branch_name)
);

create table jkj_bank.BankAccount(
Accno int,
Branch_name varchar(30),
Balance int,
PRIMARY KEY(Accno),
foreign key (Branch_name) references branch(Branch_name)
);

create table jkj_bank.BankCustomer(
Customername varchar(20),
Customer_street varchar(30),
CustomerCity varchar (35),
PRIMARY KEY(Customername)
);

create table jkj_bank.Depositer(
Customername varchar(20),
Accno int,
PRIMARY KEY(Customername,Accno),
foreign key (Accno) references BankAccount(Accno),
foreign key (Customername) references BankCustomer(Customername)
);

create table jkj_bank.Loan(
Loan_number int,
Branch_name varchar(30),
Amount int,
PRIMARY KEY(Loan_number),
foreign key (Branch_name) references branch(Branch_name)
);

create table borrower(
  Customername varchar(20),
  loan_number int,
  PRIMARY KEY (Customername, loan_number),
  foreign key(loan_number) references loan(loan_number)
);


insert into branch values('SBI_Chamrajpet','Bangalore',50000);
insert into branch values('SBI_ResidencyRoad','Bangalore',10000);
insert into branch values('SBI_ShivajiRoad','Bombay',20000);
insert into branch values('SBI_ParlimentRoad','Delhi',10000);
insert into branch values('SBI_Jantarmantar','Delhi',20000);

select * from branch;

insert into BankAccount values(1,'SBI_Chamrajpet',2000);
insert into BankAccount values(2,'SBI_ResidencyRoad',5000);
insert into BankAccount values(3,'SBI_ShivajiRoad',6000);
insert into BankAccount values(4,'SBI_ParlimentRoad',9000);
insert into BankAccount values(5,'SBI_Jantarmantar',8000);
insert into BankAccount values(6,'SBI_ShivajiRoad',4000);
insert into BankAccount values(8,'SBI_ResidencyRoad',4000);
insert into BankAccount values(9,'SBI_ParlimentRoad',3000);
insert into BankAccount values(10,'SBI_ResidencyRoad',5000);
insert into BankAccount values(11,'SBI_Jantarmantar',2000);

select * from BankAccount;

insert into BankCustomer values('Avinash','Bull_Temple_Road','Bangalore');
insert into BankCustomer values('Dinesh','Bannergatta_Road','Bangalore');
insert into BankCustomer values('Mohan','NationalCollege_Road','Bangalore');
insert into BankCustomer values('Nikil','Akbar_Road','Delhi');
insert into BankCustomer values('Ravi','Prithviraj_Road','Delhi');

select * from BankCustomer;

insert into Depositer values('Avinash',1);
insert into Depositer values('Dinesh',2);
insert into Depositer values('Nikil',4);
insert into Depositer values('Ravi',5);
insert into Depositer values('Avinash',8);
insert into Depositer values('Nikil',9);
insert into Depositer values('Dinesh',10);
insert into Depositer values('Nikil',11);

select * from Depositer;

insert into Loan values(1,'SBI_Chamrajpet',1000);
insert into Loan values(2,'SBI_ResidencyRoad',2000);
insert into Loan values(3,'SBI_ShivajiRoad',3000);
insert into Loan values(4,'SBI_ParlimentRoad',4000);
insert into Loan values(5,'SBI_Jantarmantar',5000);

select * from loan;

select Branch_name, CONCAT(assets/100000,'lakhs')assets_in_lakhs from branch;

select d.Customername from Depositer d, BankAccount b where b.Branch_name='SBI_ResidencyRoad' and d.Accno=b.Accno group by d.Customername having count(d.Accno)>=2;

create view sum_of_loan as select Branch_name, SUM(Balance) from BankAccount group by Branch_name;
select * from sum_of_loan;

select bc.Customername, CONCAT(Balance+1000,' rupees') UPDATED_BALANCE from BankAccount b, BankCustomer bc, Depositer d where bc.Customername=d.Customername and b.Accno=d.Accno and bc.Customercity='Bangalore';


Select D.customername From depositer D, bankaccount BA, branch B where D.accno=BA.accno and 
BA.branch_name= B.branch_name and B.branch_city='Delhi'
group by D.customername Having count(distinct(B.branch_name)) = (select count(branch_name) 
from branch where branch_city = 'Delhi');

select distinct Customername from borrower where Customername not in (select Customername from Depositer );

select branch_name from branch where assets>all(select assets from branch where branch_city='Bangalore');

select distinct b.Customername 
from borrower b
join loan l on b.loan_number = l.Loan_number
where l.Branch_name = 'Bangalore' 
and (l.Branch_name, b.Customername) in (
  select ba.Branch_name, d.Customername
  from Depositer d
  join BankAccount ba on d.Accno = ba.Accno
);


delete from BankAccount where branch_name IN (select branch_name from Branch where branch_city='BOMBAY');

select * from BankAccount;

Update BankAccount set Balance=Balance+Balance*0.05;

SELECT * FROM LOAN ORDER BY AMOUNT DESC;

SELECT Customername FROM Depositer UNION SELECT Customername FROM Borrower;


CREATE VIEW BRANCH_TOTAL_LOAN (BRANCH_NAME, TOTAL_LOAN) AS SELECT BRANCH_NAME, SUM(AMOUNT) FROM LOAN GROUP BY BRANCH_NAME;

UPDATE BankaCCOUNT SET BALANCE=BALANCE *1.05;
select * from bankaccount;





