SHOW DATABASES;
CREATE DATABASE iN_assignment_db3;
USE iN_assignment_db3;

                
-- Q.51 Write an SQL Query to report the name, population, and area of the big countries. 
-- Return the result table in any order . 
-- A country is big if:
-- ● it has an area of at least three million (i.e., 3000000 km2), or
-- ● it has a population of at least twenty-five million (i.e., 25000000).

CREATE TABLE world(
	name VARCHAR(20) NOT NULL,
	continent VARCHAR(15) NOT NULL,
	area INT NOT NULL,
	population BIGINT NOT NULL,
	gdp BIGINT NOT NULL,
	CONSTRAINT prime_key PRIMARY KEY(name) );
INSERT INTO world VALUES 
	('Afghanistan', 'Asia', 652230, 25500100, 203430000000),
        ('Albania', 'Europe', 28748, 2831741, 12960000000),
        ('Algeria', 'Africa', 2381741, 37100000, 188681000000),
        ('Andorra', 'Europe', 468, 78115, 3712000000),
        ('Angola', 'Africa', 1246700, 20609294, 100990000000),
        ('Dominican Republic', 'Caribbean', 48671, 9445281, 58898000000),
        ('China', 'Asia', 652230, 1365370000, 8358400000000),
        ('Colombia', 'South America', 1141748, 47662000, 369813000000),
        ('Comoros', 'Africa', 1862, 743798, 616000000),
        ('Denmark', 'Europe', 43094, 5634437, 314889000000),
        ('Djibouti', 'Africa', 23200, 886000, 1361000000),
        ('Dominica', 'Caribbean', 751, 71293, 499000000),
	('SriLanka', 'Asia', 652230, 25500100, 203430000000);
select name, population, area from world where area >= 3000000 or population >= 25000000;


-- Q.52 Write an SQL Query to report the names of the customer that are not referred by the customer with id = 2.
-- Return the result table in any order.
CREATE TABLE customer(
	id INT,
	name VARCHAR(10),
	refree_id INT,
	CONSTRAINT prime_key PRIMARY KEY(id) );
    INSERT INTO customer VALUES 
	(1,'Will',NULL),
	(2,'Jane',NULL),
	(3,'Alex',2),
	(4,'Bill',NULL),
	(5,'Zack',1),
	(6,'Mark',2);
select name from customer where ifnull(refree_id, 0) != 2;


-- Q.53 Write an SQL Query to report all customers who never order anything. 
-- Return the result table in any order .
CREATE TABLE orders(
        id INT,
        customer_id INT,
        CONSTRAINT prime_key PRIMARY KEY(id) );
INSERT INTO orders VALUES (1,3),(2,1);
CREATE TABLE customers(
        id INT,
        name VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(id));
INSERT INTO customers VALUES (1,'JOE'),(2,'HENRY'),(3,'SAM'),(4,'MAX');
select name from customers where id not in (select customer_id from orders);

-- Q.54 Write an SQL Query to find the team size of each of the employees. 
-- Return result table in any order .
CREATE TABLE employee(
        employee_id INT,
        team_id INT,
        CONSTRAINT prime_key PRIMARY KEY(employee_id) );
INSERT INTO employee VALUES (1,8),(2,8),(3,8),(4,7),(5,9),(6,9);

with cte as (select employee_id, team_id, count(employee_id) over(partition  by team_id order by employee_id) as team_size from employee)
select employee_id, team_id, max(team_size) over(partition  by team_id ) as team_size from cte order by 1;

SELECT employee_id, team_id, COUNT(employee_id) OVER(PARTITION BY team_id ORDER BY employee_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS team_size
FROM employee ORDER BY employee_id;


-- Q.55 A telecommunications company wants to invest in new countries. The company intends to invest in
-- the countries where the average call duration of the calls in this country is strictly greater than the
-- global average call duration.
-- Write an SQL query to find the countries where this company can invest.
-- Return the result table in any order.

CREATE TABLE person(
        id INT,
        name VARCHAR(20),
        phone_number VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(id));
CREATE TABLE country(
        name VARCHAR(20),
        country_code VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(country_code));
CREATE TABLE calls(
        caller_id INT,
        callee_id INT,
        duration INT);
INSERT INTO person VALUES (3,'JONATHON','051-1234567'),(21,'ELVIS','051-7654321'),(1,'MONCEF','212-1234567'),
        (2,'MAROUA','212-6523651'),(7,'MEIR','972-1234567'),(9,'RACHEL','972-0011100');
INSERT INTO calls VALUES (1,9,33),(1,2,59),(3,12,102),(3,12,330),(12,3,5),(7,9,13),(7,1,3),(9,7,1),(1,7,7),(2,9,4);
INSERT INTO country VALUES ('PERU','51'),('ISRAEL','972'),('MOROCCO','212'),('GERMANY','49'),('ETHIOPIA','251');

with cte as (select caller_id as id, sum(caller_duration) as duration, sum(caller_count) as call_count from (
(select caller_id, sum(duration) as caller_duration, count(*) as caller_count from calls group by 1)
union
(select callee_id, sum(duration) as callee_duration, count(*) as callee_count from calls group by 1)
) a group by 1),
p as (select id, name, substring(phone_number,1 , 3) as c_code from person)

 select name from country where country_code = (select convert(c_code, DECIMAL) from (
select cte.id, duration, call_count, duration/call_count as avg_duration, name, c_code from cte left join p on cte.id = p.id order by avg_duration desc limit 1) z)
;



-- Q.56 Write an SQL Query to report the device that is first logged in for each player. 
-- Return the result table in any order.
CREATE TABLE activity(
        player_id INT,
        device_id INT,
        event_date DATE,
        games_played INT,
        CONSTRAINT prime_key PRIMARY KEY(player_id, event_date) );
INSERT INTO activity VALUES (1,2,'2016-03-01',5),(1,2,'2016-03-02',6),(2,3,'2017-06-25',1),(3,1,'2016-03-02',0),(3,4,'2018-07-03',5);
select player_id,device_id from activity group by(player_id) order by event_date,player_id;

SELECT player_id,device_id FROM ( SELECT player_id, device_id, event_date, ROW_number() OVER(PARTITION BY player_id ORDER BY event_date) ranking FROM activity) 
temp_activity WHERE ranking = 1;

-- Q.57 Write an SQL Query to find the customer_number for the customer who has placed the largest number of orders.
CREATE TABLE orders1(
        order_number INT,
        customer_number INT,
        CONSTRAINT prime_key PRIMARY KEY(order_number));
INSERT INTO orders1 VALUES(1,1),(2,2),(3,3),(4,3);

select *  from orders1;
with cte as (select customer_number,order_number, count(order_number) as total_order from orders1 group by customer_number),
t1 as (select max(total_order) as max_order from cte )
select customer_number from cte where total_order = (select max_order from t1);

WITH temp_orders AS (SELECT DISTINCT customer_number, DENSE_RANK() OVER(ORDER BY total_orders DESC) AS ranking 
FROM ( SELECT  customer_number, COUNT(order_number) OVER(PARTITION BY customer_number) total_orders FROM orders1)   temp_cust_details)
SELECT  customer_number FROM temp_orders WHERE ranking = 1;



-- Q.58 Write an SQL Query to report all the consecutive available seats in the cinema.
-- Return the result table ordered by seat_id in ascending order.
CREATE TABLE cinema(
        seat_id INT AUTO_INCREMENT,
        free BOOLEAN,
        CONSTRAINT prime_key PRIMARY KEY(seat_id) );
INSERT INTO cinema (free) VALUES (1),(0),(1),(1),(1),(1),(0),(1),(1),(0),(1),(1),(1),(0),(1),(1);
select seat_id from(select seat_id, free, ifnull(lead(free) over(), 1) as next_free from cinema) t where free = next_free;
select * from cinema;



-- Q.59 Write an SQL Query to report the names of all the salespersons who did not have any 
-- orders related to the company with the name "RED".
CREATE TABLE sales_person(
        sales_id INT,
        name VARCHAR(20),
        salary INT,
        commission_rate INT,
        hire_date VARCHAR(25),
        CONSTRAINT prime_key PRIMARY KEY(sales_id));
INSERT INTO sales_person VALUES(1,'JOHN',100000,6,'4/1/2006'),(2,'AMY',12000,5,'5/1/2010'),(3,'MARK',65000,12,'12/25/2008'),(4,'PAM',25000,25,'1/1/2005'),(5,'ALEX',5000,10,'2/3/2007');
CREATE TABLE company(
        company_id INT,
        name VARCHAR(20),
        city VARCHAR(10),
        CONSTRAINT prime_key PRIMARY KEY(company_id));
INSERT INTO company VALUES(1,'RED','BOSTON'),(2,'ORANGE','NEW YORK'),(3,'YELLOW','BOSTON'),(4,'GREEN','AUSTIN');
drop table orders;
CREATE TABLE orders(
        order_id INT,
        order_date VARCHAR(30),
        company_id INT,
        sales_id INT,
        amount INT,
        CONSTRAINT prime_key PRIMARY KEY(order_id),
        CONSTRAINT company_foreign_key FOREIGN KEY (company_id) REFERENCES company(company_id),
        CONSTRAINT sales_foreign_key FOREIGN KEY (sales_id) REFERENCES sales_person(sales_id));
INSERT INTO orders VALUES(1,'1/1/2014',3,4,10000),(2,'2/1/2014',4,5,5000),(3,'3/1/2014',1,1,50000),(4,'4/1/2014',1,4,25000);
select * from sales_person;
select * from company;
select * from orders;
SELECT name  FROM sales_person
WHERE sales_id NOT IN (SELECT o.sales_id FROM orders o INNER JOIN company c ON c.company_id = o.company_id WHERE c.name = 'RED');


-- Q.60 Write an SQL Query to report for every three line segments whether they can form a triangle. 
-- Return the result table in any order.
CREATE TABLE triangle(
        x INT,
        y INT,
        z INT,
        CONSTRAINT prime_key PRIMARY KEY(x,y,z) );
INSERT INTO triangle VALUES (13,15,30),(10,20,15);
SELECT x, y, z, IF(x+y>z AND x+z>y AND y+z>x, 'YES','NO') AS is_triangle
FROM triangle;

-- Q.61 Write an SQL Query to report the shortest distance between any two points from the Point table.
CREATE TABLE point(
        x INT,
        CONSTRAINT prime_key PRIMARY KEY(x) );
INSERT INTO point VALUES(-1),(0),(2);

select min(min_dis) as shortest from(
select p1.x as x1 , p2.x as x2, case when abs(abs(p1.x) - abs(p2.x)) = 0 then 99999999999 else abs(abs(p1.x) - abs(p2.x)) end as min_dis  from point p1, point p2) a;

SELECT MIN(ABS(c1.x - c2.x)) AS shortest_distanc 
FROM point c1 INNER JOIN point c2 WHERE c1.x!=c2.x;


-- Q.62 Write a SQL Query for a report that provides the pairs (actor_id, director_id) where the actor has 
-- cooperated with the director at least three times. Return the result table in any order.
CREATE TABLE actor_director1(
        actor_id INT,
        director_id INT,
        timestamp INT,
        CONSTRAINT prime_key PRIMARY KEY(timestamp) );
INSERT INTO actor_director1 VALUES (1,1,0),(1,1,1),(1,1,2),(1,2,3),(1,2,4),(2,1,5),(2,1,6);
WITH temp_actor_director AS (SELECT DISTINCT actor_id, director_id, DENSE_RANK() OVER(ORDER BY total_movies DESC) AS ranking 
				FROM ( SELECT actor_id, director_id, COUNT(actor_id) OVER(PARTITION BY  actor_id, director_id) AS total_movies FROM actor_director1 ) temp)
SELECT actor_id, director_id FROM temp_actor_director WHERE ranking = 1;

 
-- Q.63 Write an SQL Query that reports the product_name, year, and price for each sale_id in
-- the sales table. Return the resulting table in any order.
CREATE TABLE sales(
        sale_id INT,
        product_id INT,
        year INT,
        Quantity INT,
        price INT,
        CONSTRAINT prime_key PRIMARY KEY(sale_id, year));
CREATE TABLE product(
        product_id INT,
        product_name VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(product_id));
INSERT INTO sales VALUES (1,100,2008,10,5000),(2,100,2009,12,5000),(7,200,2011,15,9000);
INSERT INTO product VALUES(100,'NOKIA'),(200,'APPLE'),(300,'SAMSUNG');
select p.product_name, s.year, s.price from sales s left join product p on s.product_id = p.product_id ;

-- Q.64 Write an SQL Query that reports the average experience years of all the employees for each project, 
-- rounded to 2 digits. Return the result table in any order.
CREATE TABLE project(
        project_id INT,
        employee_id INT,
        CONSTRAINT prime_key PRIMARY KEY(project_id, employee_id) );
INSERT INTO project VALUES (1,1),(1,2),(1,3),(2,1),(2,4);
CREATE TABLE employe(
	employee_id INT,
    name VARCHAR(20),
    experience_years INT,
    CONSTRAINT prime_key PRIMARY KEY(employee_id));
INSERT INTO employe VALUES (1,'KHALED',3), (2,'ALI',2),(3,'JOHN',1),(4,'DOE',2);

select p.project_id, round(sum(e.experience_years)/count(e.experience_years), 2) as average_years
from project p join employe e on p.employee_id = e.employee_id group by p.project_id;

SELECT DISTINCT p.project_id, ROUND(AVG(experience_years) OVER(PARTITION BY project_id), 2) AS average_years
FROM employe e INNER JOIN project p ON p.employee_id = e.employee_id;


-- Q.65 Write an SQL Query that reports the best seller by total sales price, If there is a tie, 
-- report them all. Return the result table in any order.
CREATE TABLE prod(
        product_id INT,
        product_name VARCHAR(20),
        unit_price INT,
        CONSTRAINT prime_key PRIMARY KEY(product_id));
INSERT INTO prod VALUES (1,'S8',1000),(2,'G4',800),(3,'Iphone',1400);
CREATE TABLE sale(
        seller_id INT,
        product_id INT,
        buyer_id INT,
        sale_date DATE,
        quantity INT,
        price INT,
        CONSTRAINT FOREIGN_KEY FOREIGN KEY(product_id) REFERENCES prod(product_id));
INSERT INTO sale VALUES (1,1,1,'2019-01-21',2,2000),(1,2,2,'2019-01-21',1,800),(2,2,3,'2019-01-21',1,800),(3,3,4,'2019-01-21',2,2800);
with cte as(
select p.product_id, s.seller_id, p.product_name, p.unit_price, sum(s.quantity*p.unit_price) as total_sale
from sale s left join prod p on s.product_id = p.product_id group by seller_id)
select seller_id from(select seller_id, total_sale, dense_rank() over(order by total_sale desc) as dr from cte) z where dr = 1;


-- Q.66 Write an SQL Query that reports the buyers who have bought S8 but not iphone. Note that S8 and iphone 
-- are products present in the product table. Return the result table in any order.
-- Same input table as for previous question i.e. 65
SELECT s.buyer_id FROM sale s INNER JOIN prod p ON p.product_id = s.product_id
WHERE p.product_name = 'S8' AND s.buyer_id NOT IN (SELECT s.buyer_id FROM sale S INNER JOIN prod P ON s.product_id = p.product_id 
WHERE p.product_name = 'Iphone');



-- Q.67 Write an SQL Query to compute the moving average of how much the customer paid in a seven days window 
-- (i.e., current day + 6 days before). average_amount should be rounded to two decimal places. 
-- Return result table ordered by visited_on in ascending order.
drop table customer;
CREATE TABLE customer(
	customer_id INT,
	name VARCHAR(20),
	visited_on DATE,
	amount INT,
	CONSTRAINT PRIMARY_KEY PRIMARY KEY(customer_id,visited_on) );
INSERT INTO customer VALUES (1,'JOHN','2019-01-01',100),(2,'DANIEL','2019-01-02',110),(3,'JADE','2019-01-03',120),
	(4,'KHALED','2019-01-04',130),(5,'WINSTON','2019-01-05',110),(6,'ELVIS','2019-01-06',140),(7,'ANNA','2019-01-07',150),
	(8,'MARIA','2019-01-08',80),(9,'JAZE','2019-01-09',110),(1,'JOHN','2019-01-10',130),(3,'JADE','2019-01-10',150);
with temp as(
select customer_id, name, visited_on, round(SUM(s_u_m)/7, 2) as summ from(
select customer_id, name, visited_on, SUM(amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as s_u_m from customer order by visited_on) a
group by a.visited_on)
select c1.customer_id, c1.name, c1.visited_on, c1.summ from temp c1 inner join temp c2 on c1.visited_on = date_add(c2.visited_on, INTERVAL 6 DAY);

WITH temp_customer AS (SELECT visited_on, SUM(amount) AS amount FROM customer GROUP BY visited_on),
     temp_customer2 AS (SELECT visited_on, SUM(amount) OVER(ORDER BY visited_on ROWS BETWEEN 6  PRECEDING AND CURRENT ROW) AS weekly_amount, 
			        ROUND(AVG(amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS average_amount,
			        DENSE_RANK() OVER(ORDER BY visited_on) as ranking FROM temp_customer)
SELECT visited_on, weekly_amount, average_amount FROM temp_customer2 WHERE ranking > 6;
 

-- Q.68 Write an SQL Query to find the total score for each gender on each day.
-- Return the result table ordered by gender and day in ascending order.
-- A competition is held between the female team and the male team.
-- Each row of this table indicates that a player_name and with gender has scored score_point in
-- someday. Gender is 'F' if the player is in the female team and 'M' if the player is in the male team.
CREATE TABLE scores(
        player_name VARCHAR(20),
        gender VARCHAR(20),
        day DATE,
        score_points INT,
        CONSTRAINT prime_key PRIMARY KEY(gender,day));
INSERT INTO scores VALUES('ARON','F','2020-01-01',17),('ALICE','F','2020-01-07',23),('BAJRANG','M','2020-01-07',7),('KHALI','M','2019-12-25',11),
        ('SLAMAN','M','2019-12-30',13),('JOE','M','2019-12-31',3),('JOSE','M','2019-12-18',2),('PRIYA','F','2019-12-31',23),('PRIYANKA','F','2019-12-30',17);
select player_name, gender, day, sum(score_points) as Total from scores group by gender, day;
SELECT gender, day, score_points, SUM(score_points) OVER(PARTITION BY gender ORDER BY day ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_points 
FROM scores order by gender,day;


-- Q.69 Write an SQL Query to find the start and end number of continuous ranges in the table logs. 
--  Return the result table ordered by start_id.
CREATE TABLE logs(
        log_id INT,
        CONSTRAINT prime_key PRIMARY KEY(log_id));
INSERT INTO logs VALUES(1),(2),(3),(7),(8),(10);
with cte as(
select log_id, ifnull(lead(log_id) over(), log_id) as lead_log_id, ifnull((lead(log_id) over() - log_id), 1) log_lead_log from logs)
select * from cte where log_lead_log = 1;

select log_id, ifnull((lead(log_id) over()), log_id) as lead_log_id, (log_id +1) as log_1 from logs;

SELECT MIN(log_id) AS start_id, MAX(log_id) AS end_id 
FROM (SELECT log_id, DENSE_RANK() OVER(ORDER BY log_id - RN) AS ranking FROM (SELECT log_id,ROW_number() OVER(ORDER BY log_id) AS RN FROM logs)	temp_log) temp_log2
GROUP BY ranking ORDER BY start_id;


-- Q.70 Write an SQL Query to find the number of times each student attended each exam. 
-- Return the result table ordered by student_id and subject_name.
-- Each student from the Students table takes every course from the Subjects table.
-- Each row of this table indicates that a student with ID student_id attended the exam of subject_name
CREATE TABLE students(
        student_id INT,
        student_name VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(student_id));
CREATE TABLE subjects(
        subject_name VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(subject_name));
CREATE TABLE exams(
        student_id INT,
        subject_name VARCHAR(20));
INSERT INTO students VALUES(1,'ALICE'),(2,'BOB'),(13,'JOHN'),(6,'ALEX');
INSERT INTO subjects VALUES('MATHS'),('PHYSICS'),('PROGRAMMING');
INSERT INTO exams VALUES    (1,'MATHS'),(1,'PHYSICS'),(1,'PROGRAMMING'),(2,'PROGRAMMING'),(1,'PHYSICS'),(1,'MATHS'),
        (13,'MATHS'),(13,'PROGRAMMING'),(13,'PHYSICS'),(2,'MATHS'),(1,'MATHS');
with t1 as(select student_id, subject_name, count(*) as times_attended from exams group by student_id, subject_name),
	t2 as (select student_id, student_name, subject_name from students, subjects)
select t2.student_id, t2.student_name, t2.subject_name, ifnull(t1.times_attended, 0) asattended_exams
from t2 left join t1 on t2.student_id = t1.student_id and t2.subject_name = t1.subject_name;


-- Q.71 Write an SQL Query to find employee_id of all employees that directly or indirectly 
-- report their work to the head of the company. The indirect relation between managers will not exceed 
-- three managers as the company is small. Return the result table in any order.
CREATE TABLE employees(
        employee_id INT,
        employee_name VARCHAR(20),
        manager_id INT,
        CONSTRAINT prime_key PRIMARY KEY(employee_id));
INSERT INTO employees VALUES(1,'BOSS',1),(3,'ALICE',3),(2,'BOB',1),(4,'DANIEL',2),(7,'LUIS',4),(8,'JHON',3),(9,'ANGELA',8),(77,'ROBERT',1);
















