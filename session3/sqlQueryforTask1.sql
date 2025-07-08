
ALTER TABLE employees
ADD CONSTRAINT CHK_EmployeeGender CHECK (gender IN ('M', 'F'));

ALTER TABLE dependents
ADD CONSTRAINT CHK_DependentGender CHECK (gender IN ('M', 'F'));

ALTER TABLE employees
ADD email VARCHAR(100);

CREATE TABLE locations_master
(
    location_name VARCHAR(15) PRIMARY KEY
);


INSERT INTO locations_master (location_name) VALUES ('cairo'), ('alexandria'), ('giza');


ALTER TABLE projects
ALTER COLUMN pname VARCHAR(50);

ALTER TABLE employees
DROP CONSTRAINT CHK_EmployeeGender;