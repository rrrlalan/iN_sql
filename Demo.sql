create database demo_db;
use demo_db;
create table city(
id int primary key,
city_name varchar(15),
postal_code varchar(15),
country_id int
);
insert into city values
(1, "Wien", 1010, 1),
(2, "Berlin", 10115, 2),
(3, "Hamburg", 20095, 2),
(4, "London", "EC4V 4ad", 3);
select * from city;
create table customer(
id int primary key,
customer_name varchar(30),
city_id integer,
customer_address varchar(40),
contact_person varchar(40),
email varchar(40),
phone int,
is_active int
);
select * from customer;
insert into customer values
(1,"Drogerie Wien", 1, "Deckergasse 15A", "Emil Steinbach", "emil@drogeriewien.com", 654321, 1),
(2, "Cosmetics Store", 4, "Watling Street 347", "Jeremy Corbyn", "jeremy@c-store.org", 478956, 1),
(3, "Kosmetikstudio", 3, "Rothenbaumchaussee 53", "Willy Brandt", "willy@kosmetikstudio.co", 35648, 0),
(4, "Neue Kosmetik", 1, "Karlsplatz 2", NULL, "info@neuekosmetik.co", 45698, 1),
(5, "Bio Kosmetik", 2, "Motzstraße 23", "Clara Zetkin", "clara@biokosmetik.or", 9841230, 1),
(6, "K-Wien", 1, "Kärntner Straße 204", "Maria Rauch-Kallat", "maria@kwien.org", 987456, 1),
(7, "Natural Cosmetics", 4, "Clerkenwell Road 148", "Glenda Jackson", "gena.j@natural-cosmet", 987412, 1),
(8, "Kosmetik Plus", 2, "Unter den Linden 1", "Angela Merkel", "angela@k-plus.com", 541236, 1),
(9, "New Line Cosmetics", 4, "Devonshire Street 92", "Oliver Cromwell", "oliver@nic.org", 548792, 0);

create table invoice(
id int primary key,
invoice_number varchar(60),
customer_id int,
user_account_id int,
total_price int
);
insert into invoice values
(1, "in_25181b07ba800c8d2fc967fe991807d9", 7, 4, 1436),
(2, "8fba0000fd456b27502b9f81e9d52481", 9, 2, 1000),
(3, "3b6638118246b6bcfd3dfcd9be487599", 3, 2, 360),
(4, "dfe7f0a01a682196cac0120a9adbb550", 5, 2, 1675),
(5, "2a24cc2ad4440d698878a0a1a71f70fa", 6, 2, 9500),
(6, "cbd304872ca6257716bcab8fc43204d7", 4, 2, 150);
select * from invoice;

create table invoice_item(
id int primary key,
invoice_id int,
product_id int,
quantity int,
price int,
line_total_price int
);
insert into invoice_item values
(1,1,1,20,65,1300),
(2,1,7,2,68,136),
(3,1,5,10,100,1000),
(4,3,10,2,180,360),
(5,4,1,5,65,325),
(6,4,2,10,95,950),
(7,4,5,4,100,400),
(8,5,10,100,95,9500),
(9,6,4,6,25,150);
select * from invoice_item;

create table product(
id int,
sku int,
product_name Varchar(50),
product_description varchar(60),
current_price int,
quantity_in_stock int,
is_active int
);
select * from product;
insert into product values
(1, 330120, "Game Of Thrones - URBAN DECAY" , "Game Of Thrones Eyeshadow Pa", 65,122,1),
(2, 330121, "Advanced Night Repair - ESTÉE LAUDER", "Advanced Night Repair Synchronized Reco",98,51,1),
(3, 330122, "Rose Deep Hydration - FRESH", "Rose Deep Hydration Facial To", 45,34,1),
(4, 330123, "Pore-Perfecting Moisturizer - TATCHA", "Pore-Perfecting Moisturizer & Clean",25,393,1),
(5, 330124, "Capture Youth - DIOR", "Capture Youth Serum Collecti",95,74,1),
(6, 330125, "Slice of Glow-GLOW RECIPE", "Slice of Glow Set", 45,40,1),
(7, 330126, "Healthy Skin - KIEHL'S SINCE 1851", "Healthy Skin Squad",68,154,1),
(8, 330127, "Power Pair! - IT COSMETICS", "IT's Your Skincare Power Pair! Best-Selling Moistur",80,0,0),
(9, 330128, "Dewy Skin Mist - TATCHA", "Limited Edition Dewy Skin Mist", 20,281,1),
(10, 330129, "Silk Pillowcase - SLIP", "Silk Pillowcase Duo + Scrunchie",170,0,1);
-- invoices from ids 1 through 6 correspond to city ids 4,4,3,2,1 and 1 respectively. Hence the invoice
-- items correspond to cities 4, 4, 4, 3, 2, 2, 2, 1, and 1 respectively. The city-product pairs of interest are 
-- (4, 1), (4, 7), (4, 5), (3, 10), (2, 1), (2, 21, (2, 5), (1, 10), and (1, 4).
select * from city;
select * from customer;
select * from invoice;
select * from invoice_item;
select * from product;

select city_id, product_id from invoice_item ii, invoice i, customer c
where ii.invoice_id = i.id and i.customer_id = c.id;


  select customer_name,round(max(customer_total),6) as amount_spent
    from customer c
    inner join (
                    select  customer_id,sum(total_price)over(partition by customer_id) Customer_Total, avg(total_price)over() Total_average from invoice) i
        on c.id=i.customer_id            
    where customer_total<=total_average
    group by customer_name
    order by customer_total desc;

SELECT a.customer_name, CAST((total_price) as decimal(20,6))
FROM customer as a
JOIN invoice as b ON a.id = b.customer_id
GROUP BY a.customer_name
HAVING total_price <= (SELECT AVG(total_price)*50/100 FROM invoice)
ORDER BY total_price DESC;

-- =========================================================================================

create table country(
 id int  ,
country_name VARCHAR(20)
);
drop table city;
CREATE TABLE city(
id INT,
city_name VARCHAR(20),
postal_code varchar(20),
country_id VARCHAR(20)
);

create table customer(
id int,
 customer_name varchar(20),
 city_id varchar(20),
 customer_address varchar(30),
contact_person varchar(20),
email Varchar(15),
phone_number varchar(13));

insert into city values
(1,  'Wien',     '1010', 1),
(2,  'Berlin',   '10115', 2),
(3,  'Hamburg',   '20095', 2),
(4,  'London'  , 'EC4V 4AD', 3);



