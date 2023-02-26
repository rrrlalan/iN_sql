SHOW DATABASES;
CREATE DATABASE iN_assignment_db;
USE iN_assignment_db;

CREATE TABLE city(
id int,
name VARCHAR(17),
countrycode VARCHAR(3),
district VARCHAR(20),
population int
);

-- Imported data by going Schema->Table->city->left click Import
SELECT * FROM CITY;

-- Q1. Query all columns for all American cities in the CITY table with populations larger than 100000.
-- The CountryCode for America is USA.
SELECT * FROM city WHERE countrycode = 'USA' AND population > 100000;

-- Q2. Query the NAME field for all American cities in the CITY table with populations larger than 120000.
-- The CountryCode for America is USA.
SELECT name FROM city WHERE countrycode = 'USA' AND population > 120000;

-- Q3. Query all columns (attributes) for every row in the CITY table
SELECT * FROM city;

-- Q4. Query all columns for a city in CITY with the ID 1661.
SELECT * FROM city WHERE id = 1661;

-- Q5. Query all attributes of every Japanese city in the CITY table. The COUNTRYCODE for Japan is JPN.
SELECT * FROM city WHERE countrycode = 'jpn';

-- Q6. Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.
SELECT name FROM city WHERE countrycode = 'jpn';


CREATE TABLE station(
id int,
city VARCHAR(21),
state VARCHAR(2),
lat_n int,
long_w int
);
select * from station;

-- Q7. Query a list of CITY and STATE from the STATION table.
select city, state from station;

-- Q8. Query a list of CITY names from STATION for cities that have an even ID number. Print the results
-- in any order, but exclude duplicates from the answer.
select distinct(city) from station where id % 2 = 0;

-- Q9. Find the difference between the total number of CITY entries in the table and the number of
-- distinct CITY entries in the table.
select (count(city) - count(distinct(city))) as Dublicate_city from station;

-- Q10. Query the two cities in STATION with the shortest and longest CITY names, as well as their
-- respective lengths (i.e.: number of characters in the name). If there is more than one smallest or
-- largest city, choose the one that comes first when ordered alphabetically
(select city, length(city) as length from station order by 2,1 limit 1) union
(select city, length(city) as length from station order by 2 desc, 1 asc limit 1);

-- Q11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result
-- cannot contain duplicates.
select distinct(city) from station where substr(city,1,1) in ('a', 'e', 'i', 'o', 'u');

-- Q12. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot
-- contain duplicates.
select distinct(city) from station where substr(city,length(city),1) in ('a', 'e', 'i', 'o', 'u');

-- Q13. Query the list of CITY names from STATION that do not start with vowels. Your result cannot
-- contain duplicates.
select distinct(city) from station where substr(city,1,1) not in ('a', 'e', 'i', 'o', 'u');

-- Q14. Query the list of CITY names from STATION that do not end with vowels. Your result cannot
-- contain duplicates.
select distinct(city) from station where substr(city,length(city),1) not in ('a', 'e', 'i', 'o', 'u');

-- Q15. Query the list of CITY names from STATION that either do not start with vowels or do not end
-- with vowels. Your result cannot contain duplicates.
select distinct(city) from station where (substr(city,1,1) not in ('a', 'e', 'i', 'o', 'u')) or (substr(city,length(city),1) not in ('a', 'e', 'i', 'o', 'u'));

-- Q16. Query the list of CITY names from STATION that do not start with vowels and do not end with
-- vowels. Your result cannot contain duplicates.
select distinct(city) from station where (substr(city,1,1) not in ('a', 'e', 'i', 'o', 'u')) and (substr(city,length(city),1) not in ('a', 'e', 'i', 'o', 'u'));


create table product(
product_id int,
product_name varchar(15),
unit_price int,
constraint pk_product_id primary key (product_id));

create table sales(
eller_id int,
product_id int,
buyer_id int,
sale_date date,
quantity int,
price int,
constraint fk_product_id foreign key(product_id) references product(product_id));
insert into product values(1, 'S8', 1000), (2, 'G4', 800), (3, 'iPhone', 1400);
select * from product;
insert into sales values
(1, 1, 1, '2019-01-21', 2, 2000),
(1, 2, 2, '2019-02-17' ,1 ,800),
(2, 2, 3, '2019-06-02' ,1 ,800),
(3, 3, 4, '2019-05-13' ,2 ,2800);
select * from sales;
alter table sales rename column eller_id to seller_id;
-- 17. Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,
-- between 2019-01-01 and 2019-03-31 inclusive. Return the result table in any order.
SELECT product_id, product_name FROM product WHERE product_id NOT IN(select product_id from sales where sale_date <= '2019-01-01' or sale_date >= '2019-03-31');


create table View_s(
article_id int,
author_id int,
viewer_id int,
view_date date);
insert into view_s values
(1, 3, 5, '2019-08-01'),
(1, 3, 6, '2019-08-02'),
(2, 7, 7, '2019-08-01'),
(2, 7, 6, '2019-08-02'),
(4, 7, 1, '2019-07-22'),
(3, 4, 4, '2019-07-21'),
(3, 4, 4, '2019-07-21');
-- 18. Write an SQL query to find all the authors that viewed at least one of their own articles.
-- Return the result table sorted by id in ascending order.
select distinct(author_id) as id from view_s where author_id = viewer_id order by 1;

create table Delivery(
delivery_id int,
customer_id int,
order_date date,
customer_pref_delivery_date date,
constraint pk_delivery_id primary key(delivery_id));
insert into delivery values
(1, 1, '2019-08-01', '2019-08-02'),
(2, 5, '2019-08-02', '2019-08-02'),
(3, 1, '2019-08-11', '2019-08-11'),
(4, 3, '2019-08-24', '2019-08-26'),
(5, 4, '2019-08-21', '2019-08-22'),
(6, 2, '2019-08-11', '2019-08-13');
-- 19. If the customer's preferred delivery date is the same as the order date, then the order is called immediately; otherwise, it is called scheduled.
-- Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decimal places.
select ((select count(*) from delivery where order_date = customer_pref_delivery_date) / (select count(*) from delivery))*100 as immediate_percentage;

-- 20. A company is running Ads and wants to calculate the performance of each Ad.
-- Performance of the Ad is measured using Click-Through Rate (CTR) where
create table ads(
ad_id int,
user_id int,
action enum('Clicked', 'Viewed', 'Ignored'),
 constraint m_pk_ads primary key(ad_id, user_id) );
insert into ads values
(1, 1, 'Clicked'),
(2, 2, 'Clicked'),
(3, 3, 'Viewed'),
(5, 5, 'Ignored'),
(1, 7, 'Ignored'),
(2, 7, 'Viewed'),
(3, 5, 'Clicked'),
(1, 4, 'Viewed'),
(2, 1, 'Viewed'),
(1, 2, 'Clicked');
select * from ads;
-- Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.
-- Return the result table ordered by ctr in descending order and by ad_id in ascending order in case of a tie
SELECT ad_id, ROUND(IF(SUM(action='Clicked') = 0, 0, SUM(action='Clicked') * 100 / ( SUM(action='Clicked') + SUM(action='Viewed'))), 2) as ctr
FROM Ads GROUP BY ad_id ORDER BY ctr DESC, ad_id;

with cte as(
select ad_id,action,
case when action ='Clicked' then 1 
when action='Viewed' then 0 else null end as chk
from ads )

select ad_id, ifnull(round(sum(chk)*100/count(chk), 0), 0) as ctr
from cte group by ad_id;


-- 21, Write an SQL query to find the team size of each of the employees.
-- Return result table in any order.

create table employee(
employee_id int,
team_id int,
constraint pk_emp_id primary key(employee_id));
select * from employee;
insert into employee values 
(1, 8),
(2, 8),
(3, 8),
(4, 7),
(5, 9),
(6, 9);

select employee_id,team_id, max(rnk) over(partition by team_id) as team_size
from (select employee_id,team_id, row_number() over(partition by team_id order by team_id) as rnk
from employee) t order by 1;

select e1.employee_id,count(e1.employee_id) as team_size
from employee e1 inner join employee e2
on e1.team_id=e2.team_id
group by e1.employee_id
order by e1.employee_id;

select employee_id, team_id, count(employee_id) over(partition by team_id) as team_size
from employee order by 1;


-- 22. Write an SQL query to find the type of weather in each country for November 2019.
-- The type of weather is:
--  ● Cold if the average weather_state is less than or equal 15,
--  ● Hot if the average weather_state is greater than or equal to 25, and
--  ● Warm otherwise.
-- Return result table in any order.
create table Countries(
country_id int,
country_name varchar(15),
constraint pk_c_id primary key(country_id)
);
insert into Countries values
(2, "USA"),
(3, "Australia"),
(7, "Peru"),
(5, "China"),
(8, "Morocco"),
(9, "Spain");
create table weather(
country_id int,
weather_state int,
day date,
constraint pk_day primary key(day)
);
insert into weather values
(2, 15,  "2019-11-01"),
(2, 12,  "2019-10-28"),
(2, 12,  "2019-10-27"),
(3, -2,  "2019-11-10"),
(3, 0 , "2019-11-11"),
(3, 3 , "2019-11-12"),
(5, 16,  "2019-11-07"),
(5, 18,  "2019-11-09"),
(5, 21,  "2019-11-23"),
(7, 25,  "2019-11-28"),
(7, 22,  "2019-12-01"),
(7, 20,  "2019-12-02"),
(8, 25,  "2019-11-05"),
(8, 27,  "2019-11-15"),
(8, 31,  "2019-11-25"),
(9, 7 , "2019-10-23"),
(9, 3 , "2019-12-23");
-- over(partition by country_id)
select c.country_name, t.weather_type from Countries c join 
(select country_id, avg(weather_state), CASE when avg(weather_state) <= 15 then "Cold" when avg(weather_state) >= 25 then "Hot" else "Warm" end as weather_type
from weather where year(day)=2019 and month(day)=11 group by country_id ) t on c.country_id = t.country_id;



-- 23. Write an SQL query to find the average selling price for each product. average_price should be
-- rounded to 2 decimal places.
-- Return the result table in any order.

create table prices(
product_id int,
start_date date,
end_date date,
price int,
constraint pk_pse primary key(product_id, start_date, end_date)
);
create table UnitsSold(
product_id int,
purchase_date date,
units int);
insert into prices values
(1, "2019-02-17", "2019-02-28", 5),
(1, "2019-03-01", "2019-03-22", 20),
(2, "2019-02-01", "2019-02-20", 15),
(2, "2019-02-21", "2019-03-31", 30);
insert into UnitsSold values
(1, "2019-02-25", 100),
(1, "2019-03-01", 15),
(2, "2019-02-10", 200),
(2, "2019-03-22", 30);

select * from prices p join UnitsSold us on p.product_id = us.product_id where us.purchase_date >= p.start_date and us.purchase_date <= p.end_date ;
select p.product_id, round(sum(p.price*us.units)/sum(us.units), 2) as average_price
from prices p join UnitsSold us on p.product_id = us.product_id where us.purchase_date >= p.start_date and us.purchase_date <= p.end_date 
group by p.product_id;



-- 24. Write an SQL query to report the first login date for each player.
-- Return the result table in any order.
create table activity(
player_id int,
device_id int,
event_date date,
games_played int
);
alter table activity add (constraint pk_pid_edate primary key(player_id, event_date));
insert into activity values(1, 2, "2016-03-01", 5),
(1, 2, "2016-05-02", 6),
(2, 3, "2017-06-25", 1),
(3, 1, "2016-03-02", 0),
(3, 4, "2018-07-03", 5);

select player_id, event_date as first_login from (select * from activity order by player_id, event_date) t group by player_id;
select player_id, min(event_date) as first_login from activity group by player_id;



-- 25. Write an SQL query to report the device that is first logged in for each player.
-- Return the result table in any order.
select player_id, device_id from (select * from activity order by player_id, event_date) t group by player_id;







