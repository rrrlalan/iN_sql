SHOW DATABASES;
CREATE DATABASE iN_assignment_db2;
USE iN_assignment_db2;

-- 26. Write an SQL query to get the names of products that have at least 100 units ordered in February 2020
-- and their amount.Return result table in any order

CREATE TABLE products(
        product_id INT,
        product_name VARCHAR(30),
        product_category VARCHAR(20),
        CONSTRAINT pk PRIMARY KEY(product_id) );
INSERT INTO products VALUES
        (1,'LEETCODE SOLUTIONS','BOOK'),
        (2,'JEWELS OF STRINGOLOGY','BOOK'),
        (3,'HP','LAPTOP'),
        (4,'LENOVO','LAPTOP'),
        (5,'LEETCODE KIT','T-SHIRT');
CREATE TABLE orders(
        product_id INT,
        order_date DATE,
        unit INT,
        CONSTRAINT foriegn_key FOREIGN KEY(product_id) REFERENCES products(product_id));
INSERT INTO orders VALUES
        (1,'2020-02-05',60),
        (1,'2020-02-05',70),
        (2,'2020-01-05',30),
        (2,'2020-02-05',80),
        (3,'2020-02-05',2),
        (3,'2020-02-05',3),
        (4,'2020-03-05',20),
        (4,'2020-03-05',30),
        (4,'2020-03-05',60),
        (5,'2020-02-05',50),
        (5,'2020-02-05',50),
        (5,'2020-03-05',50);
select p.product_name, t.feb_unit from products p join
(select product_id, sum(unit) as feb_unit from orders where order_date between "2020-01-31" and "2020-03-01" group by product_id) t
on p.product_id = t.product_id where t.feb_unit >= 100;

-- Q.27 Write an SQL query to find the users who have valid emails.
-- A valid e-mail has a prefix name and a domain where:
-- ● The prefix name is a string that may contain letters (upper or lower case), digits, underscore
-- '_', period '.', and/or dash '-'. The prefix name must start with a letter.
-- ● The domain is '@leetcode.com'.
-- Return the result table in any order
CREATE TABLE users(
		user_id INT,
		name VARCHAR(25),
		mail VARCHAR(25),
		CONSTRAINT prime_key PRIMARY KEY(user_id) );
INSERT INTO users VALUE 
        (1,'WINSTON','winston@leetcode.com'),
        (2,'JONATHAN','jonathonisgreat'),
        (3,'ANNABELLE','bella-@leetcode.com'),
        (4,'SALLY','sally.come@leetcode.com'),
        (5,'MARWAN','quarz-- 2020@leetcode.com'),
        (6,'DAVID','david45@gmail.com'),
        (7,'SHAPIRO','.shapo@leetcode.com');
select * from users where (mail like "_%@leetcode.com") AND mail REGEXP '^[a-zA-Z0-9][a-zA-Z0-9._-]*@';
select * from users where mail LIKE '%@leetcode.com' AND mail REGEXP '^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*\\.[a-zA-Z]{2,4}$';

-- Q.28 Write an SQL query to report the customer_id and customer_name of customers who have spent 
-- at least $100 in each month of June and July 2020. Return the result table in any order.
CREATE TABLE customer1(
        customer_id INT,
        name VARCHAR(20),
        country VARCHAR(20),
        CONSTRAINT pk PRIMARY KEY(customer_id) );
CREATE TABLE order1(
        order_id INT,
        customer_id INT,
        product_id INT,
        order_date DATE,
        quantity INT,
        CONSTRAINT prime_key PRIMARY KEY(order_id) );
CREATE TABLE product1(
        product_id INT,
        description VARCHAR(20),
        price INT,
        CONSTRAINT prime_key PRIMARY KEY(product_id) );
INSERT INTO customer1 VALUES 
        (1,'WINSTON','USA'),
        (2,'JONATHON','PERU'),
        (3,'MOUSTAFA','EGYPT');
INSERT INTO product1 VALUES 
        (10,'LC PHONE',300),
        (20,'LC T-SHIRT',10),
        (30,'LC BOOK',45),
        (40,'LC KEYCHAIN',2);
INSERT INTO order1 VALUES 
        (1,1,10,'2020-06-10',1),
        (2,1,20,'2020-07-01',1),
        (3,1,30,'2020-07-08',2),
        (4,2,10,'2020-06-15',2),
        (5,2,40,'2020-07-01',10),
        (6,3,20,'2020-06-24',2),
        (7,3,30,'2020-06-25',2),
        (9,3,30,'2020-05-08',3);

select c.customer_id, c.name from customer1 c join 
(select o.customer_id, month(o.order_date) as order_month, sum(o.quantity*p.price) as month_wise_sum, 
		count(o.customer_id) over(partition by o.customer_id) as c_id_count
from order1 o join product1 p on o.product_id = p.product_id
group by 1,2 having ((order_month = 6 and month_wise_sum >=100) or (order_month = 7 and month_wise_sum >=100))) t on t.customer_id = c.customer_id
where c_id_count>1 group by 1;

-- Q.29 Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020. 
-- Return the result table in any order.
CREATE TABLE tv_program(
        program_date DATETIME,
        content_id INT,
        channel VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(program_date, content_id) );
CREATE TABLE content(
        content_id INT,
        title VARCHAR(20),
        kids_content ENUM('Y','N'),
        content_type VARCHAR(20),
        CONSTRAINT prime_key PRIMARY KEY(content_id) );
INSERT INTO content VALUES
        (1,'LEETCODE MOVIE', 'N','MOVIES'),
        (2,'ALG. FOR KidS', 'Y','SERIES'),
        (3,'DATABASE SOLS', 'N','SERIES'),
        (4,'ALADDIN', 'Y','MOVIES'),
        (5,'CINDERELLA', 'Y','MOVIES');
INSERT INTO tv_program VALUES
		('2020-06-10 18:00',1,'LC-channel'),
        ('2020-05-11 12:00',2,'LC-channel'),
        ('2020-05-12 12:00',3,'LC-channel'),
        ('2020-05-13 14:00',4,'DISNEY-CH'),
        ('2020-06-18 14:00',4,'DISNEY-CH'),
        ('2020-07-15 16:00',5,'DISNEY-CH');

select content_id from tv_program where month(program_date) = 6;

select title from content where content_id IN (select content_id from tv_program where month(program_date) = 6) and kids_content = "Y";


-- Q.30 Write an SQL query to find the npv of each query of the Queries table. 
-- Return the result table in any order.



CREATE TABLE npv(
        id INT,
        year INT,
        npv INT,
        CONSTRAINT prime_key PRIMARY KEY(id, year) );
CREATE TABLE queries(
        id INT,
        year INT,
        CONSTRAINT prime_key PRIMARY KEY(id, year) );
INSERT INTO npv VALUES(1,2018,100),(7,2020,30),(13,2019,40),(1,2019,113),(2,2008,121),(3,2009,12),(11,2020,99),(7,2019,0);
INSERT INTO queries VALUES(1,2019),(2,2008),(3,2009),(7,2018),(7,2019),(7,2020),(13,2019);
select q.id, q.year, n.npv from queries q left join npv n on q.id = n.id where n.npv != 0; 

select q.id, q.year, n.npv from queries q inner join npv n on q.id = n.id and n.year = q.year; 

-- 31. Write an SQL query to find the npv of each query of the Queries table.
-- Return the result table in any order.
select q.id, q.year, n.npv from queries q inner join npv n on q.id = n.id and n.year = q.year; 

-- 32. -- Q.32 Write an SQL query to show the unique id of each user, If a user does not have a 
-- unique id replace just show null. Return the result table in any order.
CREATE TABLE employees(
		id INT,
		name VARCHAR(20),
		CONSTRAINT prime_key PRIMARY KEY(id) );
CREATE TABLE employees_uni(
		id INT,
		unique_id INT,
		CONSTRAINT prime_key PRIMARY KEY(id, unique_id) );
INSERT INTO employees VALUES
		(1,'ALICE'),
		(7,'BOB'),
		(11,'MEIR'),
		(90,'WINSTON'),
		(3,'JONATHAN');
INSERT INTO employees_uni VALUES
		(3,1),
		(11,2),
		(90,3);
select * from employees e left join employees_uni u on e.id = u.id;

-- -- Q.33 Write an SQL query to report the distance travelled by each user. Return the result table ordered by travelled_distance 
-- in descending order, if two or more users travelled the same distance, order them by their name in ascending order.
CREATE TABLE users1(
		id INT,
		name VARCHAR(20),
		CONSTRAINT prime_key PRIMARY KEY(id) );
INSERT INTO users1 VALUES
		(1,'ALICE'),
		(2,'BOB'),
		(3,'ALEX'),
		(4,'DONALD'),
		(7,'LEE'),
		(13,'JONATHON'),
		(19,'ELVIS');
CREATE TABLE rides1(
        id INT,
        user_id INT,
        distance INT,
        CONSTRAINT prime_key PRIMARY KEY(id) );
INSERT INTO rides1 VALUES
        (1,1,120),
        (2,2,317),
        (3,3,222),
        (4,7,100),
        (5,13,312),
        (6,19,50),
        (7,7,120),
        (8,19,400),
        (9,7,230);
select u.name, r.distance from users1 u join (select user_id, sum(distance) as distance  from rides1 group by user_id) r on u.id = r.user_id order by 2 desc,1;
select user_id, sum(distance) as distance  from rides1 group by user_id;

-- Q.34 SAME AS 26

-- Q.35 Write an SQL query to:
-- ● Find the name of the user who has rated the greatest number of movies. In case of a tie,
-- return the lexicographically smaller user name.
-- ● Find the movie name with the highest average rating in February 2020. In case of a tie, 
-- return the lexicographically smaller movie name.
CREATE TABLE users5(
		user_id INT,
		name VARCHAR(20),
		CONSTRAINT prime_key PRIMARY KEY(user_id) );
INSERT INTO users5 VALUES
		(1,'DANIEL'),
		(2,'MONICA'),
		(3,'MARIA'),
		(4,'JAMES');
CREATE TABLE movies5(
		movie_id INT,
		title VARCHAR(20),
		CONSTRAINT prime_key PRIMARY KEY(movie_id) );
INSERT INTO movies5 VALUES
		(1,'AVENGERS'),
		(2,'FROZEN 2'),
		(3,'JOKER');
CREATE TABLE movie_rating5(
		movie_id INT,
		user_id INT,
		rating INT,
		created_at DATE,
		CONSTRAINT prime_key PRIMARY KEY(movie_id, user_id) );
INSERT INTO movie_rating5 VALUES
		(1,1,3,'2020-01-12'),
		(1,2,4,'2020-02-11'),
		(1,3,2,'2020-02-12'),
		(1,4,1,'2020-01-01'),
		(2,1,5,'2020-02-17'),
		(2,2,2,'2020-02-01'),
		(2,3,2,'2020-03-01'),
		(3,1,3,'2020-02-22'),
		(3,2,4,'2020-02-25');
-- ● Find the name of the user who has rated the greatest number of movies. In case of a tie,
-- return the lexicographically smaller user name.
select user_id, count(user_id) as times_rated from movie_rating5 group by user_id;
select u.name, s.times_rated from users5 u join (select user_id, count(user_id) as times_rated from movie_rating5 group by user_id) s on u.user_id = s.user_id;

select movie_id from movie_rating5 where month(created_at) = 2 group by user_id limit 1;
select user_id, count(user_id) as times_rated from movie_rating5 group by user_id;
select title from movies5 m join (select movie_id, user_id, rating, avg(rating) avg_rating from movie_rating5 where month(created_at) = 2 group by user_id) r 
on r.movie_id = m.movie_id order by avg_rating desc limit 1;

-- Q.36 SAME AS 33



-- Q.37 SAME AS 32



-- Q.38 Write an SQL query to find the id and the name of all students who are enrolled 
-- in departments that no longer exist. Return the result table in any order.
CREATE TABLE departments(
		id INT,
		name VARCHAR(25),
		CONSTRAINT prime_key PRIMARY KEY(id) );
INSERT INTO departments VALUES
		(1,'ELECTRICAL ENGINEERING'),
		(7,'COMPUTER ENGINEERING'),
		(13,'BUSINESS ADMINISTRATION');
CREATE TABLE students(
		id INT,
		name VARCHAR(25),
		department_id INT,
		CONSTRAINT prime_key PRIMARY KEY(id) );
INSERT INTO students VALUES
		(23,'ALICE',1),
		(1,'BOB',7),
		(5,'JENNIFER',13),
		(2,'JOHN',14),
		(4,'JASMINE',77),
		(3,'STEVE',74),
		(6,'LUIS',1),
		(8,'JONATHON',7),
		(7,'DAIANA',33),
		(11,'MADELYNN',1);

select id, name from students where department_id not in (select id from departments);

-- Q.39 Write an SQL query to report the number of calls and the total call duration between 
-- each pair of distinct persons (person1, person2) where person1 < person2.
-- Return the result table in any order.
CREATE TABLE calls(
		from_id INT,
		to_id INT,
		duration INT );
INSERT INTO calls VALUES
		(1,2,59),
		(2,1,11),
		(1,3,20),
		(3,4,100),
		(3,4,200),
		(3,4,200),
		(4,3,499);
with temp as(select from_id, to_id, sum(duration) as duration, count(from_id ) from calls group by from_id, to_id)
select * from temp t1 join temp t2 on t1.from_id = t2.to_id and t1.to_id = t2.from_id
;
-- Approach 1



SELECT 
		CASE WHEN from_id < to_id THEN from_id ELSE to_id END AS person1,
		CASE WHEN from_id < to_id THEN to_id ELSE from_id END AS person2,
        COUNT(*) AS call_count,
		SUM(duration) AS total_duration
FROM calls GROUP BY person1, person2;
-- Approach 2
SELECT 
        least(from_id, to_id) AS person1,
        greatest(from_id,to_id) AS person2,
        COUNT(*) AS call_count,
        SUM(duration) AS total_duration
FROM calls GROUP BY person1, person2;


-- Q.40 SAME AS 23



-- Q.41 Write an SQL query to report the number of cubic feet of volume the inventory 
-- occupies in each warehouse. Return the result table in any order.
CREATE TABLE warehouse41(
		name VARCHAR(25),
		product_id INT,
		units INT,
		CONSTRAINT prime_key PRIMARY KEY(name,product_id) );
INSERT INTO warehouse41 VALUES
		('LCHOUSE1',1,1),
		('LCHOUSE1',2,10),
		('LCHOUSE1',3,5),
		('LCHOUSE2',1,2),
		('LCHOUSE2',2,2),
		('LCHOUSE3',4,1);
CREATE TABLE products41(
		product_id INT,
		product_name VARCHAR(25),
		width INT,
		length INT,
		height INT,
		CONSTRAINT prime_key PRIMARY KEY(product_id) );
INSERT INTO products41 VALUES
		(1,'LC-TV',5,50,40),
		(2,'LC-KEYCHAIN',5,5,5),
		(3,'LC-PHONE',2,10,10),
		(4,'LC-SHIRT',4,10,20);

select w.name as warehouse_name, sum(w.units*p.width*p.length*p.height) as volume  from warehouse41 w
left join products41 p on w.product_id = p.product_id
group by 1;



-- Q.42 Write an SQL query to report the difference between the number of 
-- apples and oranges sold each day. Return the result table ordered by sale_date.


CREATE TABLE sales42(
		sale_date DATE,
		fruit ENUM('APPLES','ORANGES'),
		sold_num INT,
		CONSTRAINT prime_key PRIMARY KEY(sale_date,fruit));
INSERT INTO sales42 VALUES
		('2020-05-01','APPLES',10),
		('2020-05-01','ORANGES',8),
		('2020-05-02','APPLES',15),
		('2020-05-02','ORANGES',15),
		('2020-05-03','APPLES',20),
		('2020-05-03','ORANGES',0),
		('2020-05-04','APPLES',15),
		('2020-05-04','ORANGES',16);

select sale_date, fruit, sold_num, diff from(
select sale_date, fruit, sold_num, (sold_num - ifnull(lead(sold_num) over(),0)) as diff from sales42 order by 1,2) t where fruit = "APPLEs" ;

SELECT sale_date,
        sum(
			CASE
			WHEN fruit = 'APPLES' THEN sold_num
			WHEN fruit = 'ORANGES' THEN -sold_num
			END ) AS difference
FROM sales42 group by 1 order BY 1;

SELECT s.sale_date, s.sold_num - ss.sold_num AS difference
FROM sales42 s INNER JOIN sales42 ss ON s.sale_date = ss.sale_date
WHERE s.fruit = 'APPLES' AND ss.fruit = 'ORANGES' ORDER BY sale_date;

SELECT sale_date, SUM(IF(fruit = 'APPLES', sold_num, -sold_num)) AS difference
FROM sales42 GROUP BY sale_date ORDER BY sale_date;


-- Q.43 Write an SQL query to report the fraction of players that logged in again on the day after the day 
-- they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players 
-- that logged in for at least two consecutive days starting from their first login date, 
-- then divide that number by the total number of players.
create table activity43(
player_id int,
device_id int,
event_date date,
games_played int,
primary key(player_id, event_date));
select * from activity43;
INSERT INTO activity43 VALUES(1, 2, '2016-03-01', 5);
INSERT INTO activity43 VALUES(1 ,2, '2016-03-02', 6);
INSERT INTO activity43 VALUES(2, 3, '2017-06-25', 1);
INSERT INTO activity43 VALUES(3, 1, '2016-03-02', 0);
INSERT INTO activity43 VALUES(3, 4, '2018-07-03', 5);

select round((select count(*) from activity43 a, activity43 b where a.player_id = b.player_id and a.event_date = date_add(b.event_date, INTERVAL 1 DAY))/
(select count(distinct player_id) from activity43), 2) as fraction;

with CTE as (SELECT player_id, event_date,
datediff(event_date, lag(event_date) over (partition by player_id ORDER BY event_date ASC)) as lag_date
FROM activity43)
SELECT round(count(distinct(player_id)) / (select count(DISTINCT(player_id)) FROM activity), 2) as fraction
from CTE WHERE lag_date = 1;


-- Q44. Write an SQL query to report the managers with at least five direct reports.
-- Return the result table in any order
CREATE TABLE employee44(
  id INT,
  name VARCHAR(30),
  department VARCHAR(30),
  manager_id INT,
  CONSTRAINT pk_employee PRIMARY KEY(id) );
INSERT INTO employee44 VALUES(101, 'John', 'A', null);
INSERT INTO employee44 VALUES(102, 'Dan', 'A', 101);
INSERT INTO employee44 VALUES(103, 'James', 'A', 101);
INSERT INTO employee44 VALUES(104, 'Amy', 'A', 101);
INSERT INTO employee44 VALUES(105, 'Anne', 'A', 101);
INSERT INTO employee44 VALUES(106, 'Ron', 'B', 101);
select * from employee44;
select name from employee44 where id = (select manager_id from employee44 group by manager_id having count(*) >=5);

WITH RECURSIVE emp_hir AS ( SELECT id, manager_id, 1 as lvl FROM employee44 WHERE manager_id is null
  UNION
SELECT em.id, em.manager_id, eh.lvl + 1 as lvl FROM emp_hir eh JOIN employee44 em ON eh.id = em.manager_id ) 
SELECT emp.name FROM emp_hir eh1 JOIN employee44 emp ON emp.id = eh1.manager_id
GROUP BY eh1.lvl, eh1.manager_id, emp.name HAVING COUNT(*) >= 5;



-- Q45. Write an SQL query to report the respective department name and number of students majoring in
-- each department for all departments in the Department table (even ones with no current students).
-- Return the result table ordered by student_number in descending order. In case of a tie, order them by
-- dept_name alphabetically.
CREATE TABLE department45(
  dept_id INT,
  dept_name VARCHAR(30),
  CONSTRAINT pk_department PRIMARY KEY(dept_id) );
CREATE TABLE student45(
  student_id INT,
  student_name VARCHAR(30),
  gender VARCHAR(1),
  dept_id INT,
  CONSTRAINT pk_student PRIMARY KEY(student_id),
  CONSTRAINT fk_department FOREIGN KEY (dept_id) REFERENCES department45(dept_id));
INSERT INTO department45 VALUES(1, 'Engineering');
INSERT INTO department45 VALUES(2, 'Science');
INSERT INTO department45 VALUES(3, 'Law');
INSERT INTO student45 VALUES(1, 'Jack', 'M', 1);
INSERT INTO student45 VALUES(2, 'Jane', 'F', 1);
INSERT INTO student45 VALUES(3, 'Mark', 'M', 2);

select dept_name, count(student_id) as student_number from department45 d
left join student45 s on d.dept_id = s.dept_id group by 1 order by 2 desc,1;



-- Q46. Write an SQL query to report the customer ids from the Customer table that bought all the products in
-- the Product table.
CREATE TABLE customer46(
  customer_id INT,
  product_key INT );
CREATE TABLE product46(
  product_key INT,
  CONSTRAINT pk_product PRIMARY KEY(product_key));
INSERT INTO customer46 VALUES(1, 5);
INSERT INTO customer46 VALUES(2, 6);
INSERT INTO customer46 VALUES(3, 5);
INSERT INTO customer46 VALUES(3, 6);
INSERT INTO customer46 VALUES(1, 6);
INSERT INTO customer46 VALUES(1, 7);
INSERT INTO product46 VALUES(5);
INSERT INTO product46 VALUES(6);
INSERT INTO product46 VALUES(7);
select  if( (3, 5) in (5, 2, 3) ,2,3);




select c.customer_id from customer46 c 
group by c.customer_id having count(distinct c.product_key) = (select count(*) from product46);


-- Q47.Write an SQL query that reports the most experienced employees in each project. In case of a tie,
-- report all employees with the maximum number of experience years. Return the result table in any order.
CREATE TABLE project47(
  project_id INT,
  employee_id INT,
  CONSTRAINT pk_project PRIMARY KEY(project_id, employee_id));
CREATE TABLE employee47(
  employee_id INT,
  name VARCHAR(30),
  experience_years INT,
  CONSTRAINT pk_employee PRIMARY KEY(employee_id) );
INSERT INTO project47 VALUES(1, 1);
INSERT INTO project47 VALUES(1, 2);
INSERT INTO project47 VALUES(1, 3);
INSERT INTO project47 VALUES(2, 1);
INSERT INTO project47 VALUES(2, 4);
INSERT INTO employee47 VALUES(11, 'Khaled', 3);
INSERT INTO employee47 VALUES(2, 'Ali', 2);
INSERT INTO employee47 VALUES(3, 'John', 3);
INSERT INTO employee47 VALUES(4, 'Doe', 2);

select p.project_id, p.employee_id, max(experience_years) from project47 p join employee47 e on p.employee_id = e.employee_id group by p.project_id, p.employee_id;

WITH employee_exp_serialized AS(SELECT e.employee_id, p.project_id,
    DENSE_RANK() OVER(PARTITION BY p.project_id ORDER BY e.experience_years DESC) as experience_serial
  FROM employee47 e JOIN project47 p ON p.employee_id = e.employee_id)
SELECT project_id, employee_id FROM employee_exp_serialized WHERE experience_serial = 1;


-- Q48. Write an SQL query that reports the books that have sold less than 10 copies in the last year,
-- excluding books that have been available for less than one month from today. Assume today is
-- 2019-06-23.
CREATE TABLE books48(
  book_id INT,
  name VARCHAR(30),
  avaialable_from DATE,
  CONSTRAINT pk_books PRIMARY KEY(book_id));
CREATE TABLE orders48(
  order_id INT,
  book_id INT,
  quantity INT,
  dispatch_date DATE,
  CONSTRAINT pk_orders PRIMARY KEY(order_id),
  CONSTRAINT fk_orders FOREIGN KEY (book_id) REFERENCES books48(book_id) );

INSERT INTO books48 VALUES(1, 'Kalila And Demna', '2010-01-01');
INSERT INTO books48 VALUES(2, '28 Letters', '2012-05-12');
INSERT INTO books48 VALUES(3, 'The Hobbit', '2019-06-10');
INSERT INTO books48 VALUES(4, '13 Reasons Why', '2019-06-01');
INSERT INTO books48 VALUES(5, 'The Hunger Games', '2008-09-21');
-- INSUFFICIENT DATA ORDERS TABLE DATA IS NOT GIVEN
select * from books48;
WITH last_year_sales AS(SELECT o.book_id, sum(quantity) AS total_sold
  FROM orders48 o WHERE o.dispatch_date >= DATE_SUB("2019-06-23", INTERVAL 1 YEAR) GROUP BY o.book_id)
SELECT b.name FROM books48 b LEFT JOIN last_year_sales l_y_sales ON b.book_id = l_y_sales.book_id
WHERE(l_y_sales.total_sold < 10 OR l_y_sales.total_sold is NULL) AND b.avaialable_from <= DATE_SUB("2019-06-23", INTERVAL 1 MONTH);

-- Q49. Write a SQL query to find the highest grade with its corresponding course for each student. In case of
-- a tie, you should find the course with the smallest course_id.
-- Return the result table ordered by student_id in ascending order
CREATE TABLE enrollments(
  student_id INT,
  course_id INT,
  grade INT,
  CONSTRAINT pk_enrollments PRIMARY KEY(student_id, course_id));
INSERT INTO enrollments VALUES(2, 2, 95);
INSERT INTO enrollments VALUES(2, 3, 95);
INSERT INTO enrollments VALUES(1, 1, 90);
INSERT INTO enrollments VALUES(1, 2, 99);
INSERT INTO enrollments VALUES(3, 1, 80);
INSERT INTO enrollments VALUES(3, 2, 75);
INSERT INTO enrollments VALUES(3, 3, 82);
select * from enrollments;

select * from enrollments group by student_id order by course_id desc ;

WITH serailized_enrollments AS( SELECT *, DENSE_RANK() OVER(PARTITION BY student_id ORDER BY grade DESC, course_id) AS serial FROM enrollments)
SELECT student_id, course_id, grade FROM serailized_enrollments WHERE serial = 1 ;

SELECT mgt.student_id, e.course_id, e.grade FROM enrollments e
JOIN (SELECT student_id, max(grade) as max_grade FROM enrollments GROUP BY student_id) as mgt
ON mgt.student_id = e.student_id and mgt.max_grade = e.grade ORDER BY student_id;



-- Q50.Write an SQL query to find the winner in each group.
-- Return the result table in any order.
-- The winner in each group is the player who scored the maximum total points within the group. In the
-- case of a tie, the lowest player_id wins.
-- DATA IS NOT MATCHING FROM ACTUTAL GIVEN DATA ACCORDING TO QUESTIONS
CREATE TABLE players50(
  player_id INT,
  group_id INT,
  CONSTRAINT pk_players PRIMARY KEY(player_id) );
CREATE TABLE matches50(
  match_id INT,
  first_player INT,
  second_player INT,
  first_score INT,
  second_score INT,
  CONSTRAINT pk_matches PRIMARY KEY(match_id) );

INSERT INTO players50 VALUES(15, 1);
INSERT INTO players50 VALUES(25, 1);
INSERT INTO players50 VALUES(30, 1);
INSERT INTO players50 VALUES(45, 1);
INSERT INTO players50 VALUES(10, 2);
INSERT INTO players50 VALUES(35, 2);
INSERT INTO players50 VALUES(50, 2);
INSERT INTO players50 VALUES(20, 3);
INSERT INTO players50 VALUES(40, 3);

INSERT INTO matches50 VALUES(1, 15, 45, 3, 0);
INSERT INTO matches50 VALUES(2, 30, 25, 1, 2);
INSERT INTO matches50 VALUES(3, 30, 15, 2, 0);
INSERT INTO matches50 VALUES(4, 40, 20, 5, 2);
INSERT INTO matches50 VALUES(5, 35, 50, 1, 1);

WITH player_score AS( SELECT p.group_id, p.player_id, 
SUM(CASE WHEN p.player_id = m.first_player THEN m.first_score WHEN p.player_id = m.second_player THEN m.second_score END) AS score
  FROM players50 p JOIN matches50 m ON p.player_id = m.first_player OR p.player_id = m.second_player GROUP BY p.group_id, p.player_id ),
ranked_player AS( SELECT group_id, player_id, score, DENSE_RANK() OVER (PARTITION BY group_id ORDER BY score DESC,player_id) AS player_rank FROM player_score )
SELECT group_id, player_id FROM ranked_player WHERE player_rank = 1 ;

