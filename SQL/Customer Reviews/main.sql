CREATE TABLE Customers (
    customer_id INTEGER PRIMARY KEY,
    name TEXT,
    contact_info TEXT
);

CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT
);

CREATE TABLE Reviews (
    review_id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    product_id INTEGER,
    rating INTEGER,
    review_text TEXT,
    date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Insert Customers
INSERT INTO Customers (name, contact_info) VALUES
('John Doe', 'john.doe@example.com'),
('Alice Smith', 'alice.smith@example.com'),
('Bob Johnson', 'bob.johnson@example.com'),
('Emma Davis', 'emma.davis@example.com'),
('Michael Brown', 'michael.brown@example.com'),
('Sarah Wilson', 'sarah.wilson@example.com'),
('David Lee', 'david.lee@example.com'),
('Emily White', 'emily.white@example.com'),
('Daniel Miller', 'daniel.miller@example.com'),
('Olivia Taylor', 'olivia.taylor@example.com');


-- Insert Products
INSERT INTO Products (product_name) VALUES
    ('Product A'),
    ('Product B'),
    ('Product C');

-- Insert Reviews
INSERT INTO Reviews (customer_id, product_id, rating, review_text, date) VALUES
(1, 1, 5, 'Excellent product!', '2024-03-01'),
(2, 1, 4, 'Good product, but could be improved.', '2024-03-02'),
(1, 2, 3, 'Not satisfied with the quality.', '2024-03-03'),
(3, 3, 5, 'Amazing experience with Product C.', '2024-03-04'),
(2, 2, 2, 'Very disappointed with Product B.', '2024-03-05'),
(1, 3, 4, 'Impressed with Product C features.', '2024-03-06'),
(4, 1, 5, 'Great service and fast delivery.', '2024-03-07'),
(5, 2, 4, 'Decent product for the price.', '2024-03-08'),
(6, 3, 2, 'Not recommended, poor quality.', '2024-03-09'),
(7, 1, 3, 'Average product, nothing special.', '2024-03-10'),
(8, 2, 4, 'Satisfied with the purchase.', '2024-03-11'),
(9, 3, 5, 'Best product I have ever bought!', '2024-03-12'),
(10, 1, 2, 'Terrible experience, never buying again.', '2024-03-13'),
(1, 2, 4, 'Improved quality compared to previous purchases.', '2024-03-14'),
(2, 3, 3, 'Product meets expectations, nothing extraordinary.', '2024-03-15'),
(3, 1, 5, 'Highly recommend, great value for money.', '2024-03-16'),
(4, 2, 1, 'Worst purchase ever, complete waste of money.', '2024-03-17'),
(5, 3, 4, 'Good product with fast shipping.', '2024-03-18'),
(6, 1, 2, 'Disappointed, did not live up to the hype.', '2024-03-19'),
(7, 2, 5, 'Exceeded expectations, fantastic product!', '2024-03-20'),
(8, 3, 3, 'Average quality, but the price is reasonable.', '2024-03-21'),
(9, 1, 4, 'Impressive features, would recommend.', '2024-03-22'),
(10, 2, 1, 'Regret buying, poor quality and bad customer service.', '2024-03-23'),
(1, 3, 5, 'Absolutely love it, worth every penny!', '2024-03-24'),
(2, 1, 3, 'Okay product, but there are better alternatives.', '2024-03-25');

-- RUN PREVIEW
.print #######################
.print #### SQL Challenge ####
.print #######################

.print \n Customers table
.mode box
select * from Customers limit 5;

.print \n Products table
.mode box
select * from Products limit 5;

.print \n Reviews table
.mode box
select * from Reviews limit 5;

--1. Find the average rating for each product.
select A.product_id, A.product_name, AVG(B.rating) as avg_rating 
from Products A 
left join Reviews B on A.product_id = B.product_id
group by 1,2 ;

--2.Extrack customers who review rating more than 4.
select A.customer_id, A.name, rating
from Customers A
join Reviews B on A.customer_id = B.customer_id
group by 1,2
having rating > 4;

--3. Count number of customers reviwers .
select A.customer_id, A.name, count(B.review_id) as number_of_reviews
from Customers A
join Reviews B on A.customer_id = B.customer_id
group by 1,2;

--4.Find Average rating by day of week .
select strftime('%w',date), AVG(rating) as avg_rating
from Reviews
group by 1;

--5.Find what is product with rating equal or more than 3.5 .
select A.product_id, A.product_name, avg(B.rating) as avg_rating
from Products A 
left join Reviews B on A.product_id = B.product_id
group by 1,2
having avg_rating >= 3.5;

--6.Count negative review text .
select review_text, count(review_text) as negative_reviews
from Reviews
where review_text like '%disappointed%'
group by 1;

--7.Find customers who have positive revies (Text with “excellent” ,“impressive” or “recommend”) and high rating(ratin equal or more than 4)
select customer_id, review_text
from Reviews
where (review_text like '%excellent%' or review_text like '%impressive%' or
       review_text like '%recommend%') and rating >= 4;

--8.How many average length text of customers
select A.name,A.contact_info, avg(length(B.review_text)) as average_words
from Customers A
join Reviews B on A.customer_id = B.customer_id
group by A.customer_id
order by average_words desc;


