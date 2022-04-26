CREATE DATABASE pizza_orders;
USE pizza_orders;

CREATE TABLE users (
user_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
 phone_number varchar(12) NOT NULL,
 first_name varchar(35),
 last_name varchar(35)
 );
 
INSERT INTO users
VALUES(DEFAULT,'226-555-4982', 'Trevor', 'Page'),
(DEFAULT, '555-555-9498', 'John', 'Doe');

CREATE TABLE pizzas (pizza_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, pizza_type varchar(25), price Decimal(12,2));

INSERT INTO pizzas
VALUES(DEFAULT, 'Pepperoni & Cheese', 7.99),
(DEFAULT, 'Vegetarian', 9.99),
(DEFAULT, 'Meat Lovers', 14.99),
(DEFAULT, 'Hawaiian', 12.99);


CREATE TABLE orders (order_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, order_time DATETIME NOT NULL);

INSERT INTO orders
VALUES(DEFAULT, '2014-10-09 09:47:00'), 
(DEFAULT, '2014-10-09 13:20:00'), 
(DEFAULT, '2014-10-09 09:47:00');

CREATE TABLE user_orders (user_id INT NOT NULL, order_id INT NOT NULL);

ALTER TABLE user_orders
ADD FOREIGN KEY (user_id) REFERENCES users(user_id);
ALTER TABLE user_orders
ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);


INSERT INTO user_orders
VALUES (1,1),
(1,3),
(2,2); 

CREATE TABLE pizza_orders (pizza_id INT NOT NULL, order_id INT NOT NULL);
ALTER TABLE pizza_orders
ADD FOREIGN KEY (pizza_id) REFERENCES pizzas(pizza_id);
ALTER TABLE pizza_orders
ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);

INSERT INTO pizza_orders 
VALUES(1,1),
(3,1),(2,2),
(3,2),(3,2),
(3,3),(4,3);

-- Q4

SELECT 
u.user_id,
u.first_name,
u.last_name,
SUM(price) AS `total spent`

FROM pizzas p
JOIN pizza_orders po USING (pizza_id)
JOIN orders o USING (order_id)
JOIN user_orders uo USING (order_id)
JOIN users u USING (user_id)

GROUP BY u.user_id
ORDER BY `total spent` DESC 
LIMIT 3;

-- Q5
/* Q5: Modify the query from Q4 
to separate the orders not just 
by customer, but also by date 
so they can see how much 
each customer is ordering 
on which date. */

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

select 
u.user_id,
u.first_name,
u.last_name,
CAST(order_time AS DATE) AS `order date`,
SUM(price) AS `daily total`
FROM
orders o
join pizza_orders po USING (order_id)
join pizzas p using (pizza_id)
join user_orders uo on uo.order_id = o.order_id
join users u on u.user_id = uo.user_id

group by u.user_id, o.order_time
order by `daily total` desc;