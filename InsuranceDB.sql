show databases;
use jkjdatabase;

create table person(driver_id varchar(20), name varchar(20), address varchar(30), primary key(driver_id));
create table car(reg_num varchar(10),model varchar(10), year int, primary key(reg_num));

desc person;
desc car;

create table accident(report_num int, accident_date date, location varchar(20),primary key(report_num));
desc accident;

create table owns(
driver_id varchar(10),
 reg_num varchar(10),
 primary key(driver_id, reg_num), 
 foreign key(driver_id) references person(driver_id), 
 foreign key(reg_num) references car(reg_num));
desc owns;

create table participated (
driver_id varchar(10),
reg_num varchar(10),
report_num int,
damage_amount int,
primary key(driver_id, reg_num, report_num),
foreign key(driver_id) references person(driver_id),
foreign key(reg_num) references car(reg_num),
foreign key(report_num) references accident(report_num));

desc participated;

insert into person(driver_id, name, address)
values('A01','Richard','SrinivaS nAGAR');

insert into person(driver_id, name, address)
values('A02','Pradeep','Rajaji Nagar');

insert into person(driver_id, name, address)
values('A03','Smith','Ashok Nagar');

insert into person(driver_id, name, address)
values('A04','Venu','N R Colony');

insert into person(driver_id, name, address)
values('A05','John','Hanumanth Nagar');

SELECT * from person;

insert into car(reg_num,model,year)
values('KA052250','Indica','1990');

insert into car(reg_num,model,year)
values('KA031181','Lancer','1957');

insert into car(reg_num,model,year)
values('KA095477','Toyota','1998');

insert into car(reg_num,model,year)
values('KA053408','Honda','2008');

insert into car(reg_num,model,year)
values('KA041702','Audi','2025');

select * from car;

insert into owns(driver_id, reg_num)
values('A01','KA052250');

insert into owns(driver_id, reg_num)
values('A02','KA031181');

insert into owns(driver_id, reg_num)
values('A03','KA095477');

insert into owns(driver_id, reg_num)
values('A04','KA053408');

insert into owns(driver_id, reg_num)
values('A05','KA041702');

select * from owns;

insert into accident values (11,'2003-01-01','Mysore Road');
insert into accident values (12,'2004-02-02','South end Circle');
insert into accident values (13,'2003-01-21','Bull temple Road');
insert into accident values (14,'2008-02-17','Mysore Road');
insert into accident values (15,'2004-03-05','Kanakpura Road');

select * from accident;

insert into participated values('A01','KA052250',11,10000);
insert into participated values('A02','KA053408',12,50000);
insert into participated values('A03','KA095477',13,25000);
insert into participated values('A04','KA031181',14,3000);
insert into participated values('A05','KA041702',15,5000);

select * from participated;


select * from car order by year asc;

select count(report_num)
from car c, participated p
where c.reg_num=p.reg_num and c.model='Lancer';

select count(distinct driver_id) CNT
from participated a, accident b
where a.report_num=b.report_num and b.accident_date like '________21%';

SELECT * FROM PARTICIPATED ORDER BY DAMAGE_AMOUNT DESC;

SELECT AVG(DAMAGE_AMOUNT) FROM PARTICIPATED;


DELETE FROM PARTICIPATED WHERE DAMAGE_AMOUNT;
(SELECT AVG(DAMAGE_AMOUNT) FROM PARTICIPATED);

SELECT NAME FROM PERSON A, PARTICIPATED B WHERE A.DRIVER_ID = B.DRIVER_ID AND DAMAGE_AMOUNT;
(SELECT AVG(DAMAGE_AMOUNT) FROM PARTICIPATED);

SELECT MAX(DAMAGE_AMOUNT) FROM PARTICIPATED;

update participated set damage_amount=25000 where reg_num='KA053408' and report_num=12;

insert into accident values(16,'2015-03-08','Domlur');
 






