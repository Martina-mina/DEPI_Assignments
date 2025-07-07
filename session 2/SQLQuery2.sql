create database databaseSession2

use databaseSession2

create table employees
(
ssn int primary key identity (1,1) ,
birthDate date ,
gender char(1) not null ,
fname varchar (15) not null ,
lname varchar (15) not null ,
dnum int , 
super_ssn int references employees(ssn)
);


create table departments
(
dnum int primary key identity (1,1) ,
hiringDate date , 
dname varchar (15) not null ,
manager_ssn int unique references employees(ssn),
);

-- علشان نظبط ال foreign key 
alter table employees
add foreign key (dnum) references departments(dnum);


create table department_locations
(
dnum int references departments(dnum),
location varchar (15) default 'cairo' ,
primary key (dnum , location )
);


create table projects
(
pnum int primary key identity (10,10) ,
pname varchar (15) not null,
location varchar (15) default 'cairo' ,
dnum int references departments(dnum) ,
);

create table dependents
(
name varchar (15) not null,
birthDate date ,
gender char(1) not null ,
Essn int references employees(ssn) ,
primary key (name ,Essn )
);

create table emp_projects
(
Essn int references employees(ssn) ,
pnum int references projects(pnum) ,
numOfHours int not null, 
primary key (Essn, pnum) ,
);



INSERT INTO Employees (fname, lname, birthDate, gender, dnum, super_ssn) VALUES
('Ahmed', 'Mohamed', '1980-01-15', 'M', NULL, NULL),
('Fatma', 'Ali', '1990-05-20', 'F', NULL, NULL),
('Khaled', 'Saad', '1985-11-10', 'M', NULL, NULL),
('Mona', 'Hassan', '1992-03-25', 'F', NULL, NULL),
('Tarek', 'Mahmoud', '1975-08-01', 'M', NULL, NULL);

INSERT INTO Departments (dname, hiringDate, manager_ssn) VALUES
('IT', '2020-01-01', (SELECT ssn FROM Employees WHERE fname = 'Ahmed' AND lname = 'Mohamed')),
('HR', '2021-03-10', (SELECT ssn FROM Employees WHERE fname = 'Fatma' AND lname = 'Ali')),
('Finance', '2019-07-20', (SELECT ssn FROM Employees WHERE fname = 'Khaled' AND lname = 'Saad'));

UPDATE Employees
SET dnum = (SELECT dnum FROM Departments WHERE dname = 'HR')
WHERE fname = 'Mona' AND lname = 'Hassan';

-- delete ahmed mohamed
INSERT INTO Dependents (name, birthDate, gender, Essn) VALUES
('Child1', '2010-02-01', 'M', (SELECT ssn FROM Employees WHERE fname = 'Ahmed' AND lname = 'Mohamed')),
('Child2', '2015-07-10', 'F', (SELECT ssn FROM Employees WHERE fname = 'Ahmed' AND lname = 'Mohamed'));

DELETE FROM Dependents
WHERE name = 'Child1' AND Essn = (SELECT ssn FROM Employees WHERE fname = 'Ahmed' AND lname = 'Mohamed');


SELECT *
FROM Employees
WHERE dnum = (SELECT dnum FROM Departments WHERE dname = 'IT');


INSERT INTO Projects (pname, location, dnum) VALUES
('Website Redesign', 'Cairo', (SELECT dnum FROM Departments WHERE dname = 'IT')),
('HR System', 'Alexandria', (SELECT dnum FROM Departments WHERE dname = 'HR'));

