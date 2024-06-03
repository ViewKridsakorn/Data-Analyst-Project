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


