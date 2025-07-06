create database databaseSession1

use databaseSession1

create table employees 
(
ssn int primary key identity (1,1) ,
birthDate date ,
gender char(1) not null ,
fname varchar (15) not null ,
lname varchar (15) not null ,
dnum int ,
super_ssn int references employees(ssn)
)

create table departments 
(
dnum int primary key identity (1,1) ,
hiringhDate date ,
dname varchar (15) not null ,
manager_ssn int references employees(ssn)
)

alter table employees 
add foreign key (dnum) references departments(dnum)

create table department_locations
(
dnum int references departments(dnum),
location varchar (15) default 'cairo ' ,
primary key (dnum , location )
)

create table projects 
(
pnum int primary key identity (10,10) ,
pname varchar (15) not null,
location varchar (15) default 'cairo ' ,
dnum int references departments(dnum),
)

create table dependents  
(
name varchar (15) not null,
birthDate date ,
gender char(1) not null ,
Essn int references  employees(ssn) ,
primary key (name ,Essn )
)

create table emp_projects  
(
Essn int  references  employees(ssn)  ,
pnum int references projects(pnum) ,
numOfHours int,
)

