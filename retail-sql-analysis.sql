DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    city          VARCHAR(50),
    signup_date   DATE
);

CREATE TABLE categories (
    category_id   INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE products (
    product_id    INT PRIMARY KEY,
    product_name  VARCHAR(100) NOT NULL,
    category_id   INT,
    price         DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id      INT PRIMARY KEY,
    customer_id   INT,
    order_date    DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id      INT,
    product_id    INT,
    quantity      INT NOT NULL,
    unit_price    DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ---------------- Sample data ----------------

INSERT INTO customers VALUES
(1,'Asha','Rao','Bengaluru','2024-01-12'),
(2,'Vikram','Shah','Mumbai','2024-02-03'),
(3,'Priya','Nair','Chennai','2024-02-20'),
(4,'Rahul','Verma','Delhi','2024-03-05'),
(5,'Meera','Iyer','Hyderabad','2024-03-18'),
(6,'Karan','Mehta','Pune','2024-04-01'),
(7,'Sneha','Kulkarni','Bengaluru','2024-04-15'),
(8,'Arjun','Reddy','Hyderabad','2024-05-02'),
(9,'Divya','Menon','Kochi','2024-05-20'),
(10,'Suresh','Pillai','Chennai','2024-06-10');

INSERT INTO categories VALUES
(1,'Electronics'),
(2,'Home & Kitchen'),
(3,'Books'),
(4,'Sports');

INSERT INTO products VALUES
(1,'Wireless Mouse',1,799.00),
(2,'Bluetooth Speaker',1,1999.00),
(3,'USB-C Charger',1,999.00),
(4,'Non-stick Pan',2,1499.00),
(5,'Mixer Grinder',2,3499.00),
(6,'Data Analysis Handbook',3,599.00),
(7,'SQL for Beginners',3,449.00),
(8,'Yoga Mat',4,899.00),
(9,'Dumbbell Set',4,2199.00),
(10,'Running Shoes',4,2999.00);

INSERT INTO orders VALUES
(1,1,'2024-06-01'),
(2,2,'2024-06-02'),
(3,1,'2024-06-05'),
(4,3,'2024-06-07'),
(5,4,'2024-06-10'),
(6,5,'2024-06-12'),
(7,2,'2024-06-15'),
(8,6,'2024-06-18'),
(9,7,'2024-06-20'),
(10,3,'2024-06-22'),
(11,8,'2024-06-25'),
(12,9,'2024-06-27'),
(13,1,'2024-06-29'),
(14,10,'2024-07-01'),
(15,5,'2024-07-03');

INSERT INTO order_items VALUES
(1,1,1,1,799.00),
(2,1,3,2,999.00),
(3,2,2,1,1999.00),
(4,3,6,1,599.00),
(5,4,4,1,1499.00),
(6,4,5,1,3499.00),
(7,5,7,3,449.00),
(8,6,8,2,899.00),
(9,7,9,1,2199.00),
(10,8,10,1,2999.00),
(11,9,1,2,799.00),
(12,10,2,2,1999.00),
(13,11,6,1,599.00),
(14,12,3,1,999.00),
(15,13,4,2,1499.00),
(16,14,10,1,2999.00),
(17,15,9,1,2199.00),
(18,2,7,1,449.00),
(19,6,5,1,3499.00),
(20,10,8,3,899.00);
show tables;
describe customers;
select * from orders;

# Which customers have spent the most overall?
SELECT c.customer_id, CONCAT(c.first_name, ' ',c.last_name) as customer_name,
sum(oi.quantity * oi.unit_price) as total_spent
from customers c
join orders o on o.customer_id = c.customer_id
join order_items oi on oi.order_id = o.order_id
group by c.customer_id, customer_name
order by total_spent DESC;


# What are the top 3 best-selling categories by revenue?
with category_revenue as (
     SELECT 
		cat.category_name ,
        sum(oi.quantity * oi.unit_price) as revenue
	from order_items oi
    join products p on p.product_id = oi.product_id
    join categories cat on cat.category_id = p.category_id
    group by cat.category_name
		)
        select * from  category_revenue
        order by revenue DESC
        limit 3;

# Rank products by revenue within their own category
select cat.category_name,
	p.product_name,
	sum(oi.quantity * oi.unit_price) as product_revenue,
	rank() over(partition by cat.category_name order by sum(oi.quantity * oi.unit_price) desc) as rank_in_category
	from order_items oi
	join products p on oi.product_id = p.product_id
	join categories cat on p.category_id = cat.category_id
 group by cat.category_name, p.product_name
 order by cat.category_name, rank_in_category;
 
# Which customers spent more than the average customer?

SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) as customer_name,
    sum(oi.quantity * oi.unit_price) as total_spent
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
group by c.customer_id, customer_name
having sum(oi.quantity * oi.unit_price) > (
    select avg(customer_total) from (
        select sum(oi2.quantity * oi2.unit_price) AS customer_total
        from orders o2
        join order_items oi2 on o2.order_id = oi2.order_id
        group by o2.customer_id
    ) as customer_totals
)
order by total_spent DESC;
 
# What is total revenue by month
select DATE_FORMAT(o.order_date, '%Y-%m') as order_month,
    SUM(oi.quantity * oi.unit_price) as monthly_revenue
from orders o join order_items oi on o.order_id = oi.order_id
group by order_month
order by order_month;