SHOW DATABASES;
CREATE DATABASE iN_assignment_db4;
USE iN_assignment_db4;

 -- Q.76 Write an SQL Query to find the salaries of the employees after applying taxes. 
 -- Round the salary to the nearest integer.


 CREATE TABLE salaries(
        company_id INT,
        employee_id INT,
        employee_name VARCHAR(20),
        salary INT,
        CONSTRAINT prime_key PRIMARY KEY(company_id, employee_id)
    );


INSERT INTO salaries VALUES    
        (1,1,'TONY',2000),
        (1,2,'PRONUB',21300),
        (1,3,'TYRROX',10800),
        (2,1,'PAM',300),
        (2,7,'BASSEM',450),
        (2,9,'HERMIONE',700),
        (3,7,'BOCABEN',100),
        (3,2,'OGNJEN',2200),
        (3,13,'NYAN CAT',3300),
        (3,15,'MORNING CAT',7777);