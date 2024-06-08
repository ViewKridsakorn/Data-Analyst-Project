

--1. Observe total sales by item and arrange with item id.
select A.item_id,A.item_name, sum(A.price * B.quantity) as Total_sale
from Items A  
join Invoices B on A.item_id = B.item_id
group by A.item_id,item_name
order by A.item_id;


--2. Observe total amount of customers and arrange them in descending order.
select A.customer_id, A.email, sum(C.price * B.quantity) as Total_Sale
from Customers A 
join Invoices B on A.customer_id = B.customer_id
join Items C on B.item_id = C.item_id
group by C.customer_id,C.email
order by Total_Sale desc;


--3.Categorize product id 3,4,5,8,9 with Dairy Products and Non-Dairy Products.
select item_id,
       item_name, case 
              when  item_iD in (3,4,5,8,9) then 'Dairy Products'
              else 'Non-Dairy Products'
              end as Product_Category
from Items ;


--4. Calculate product sale of Dairy Products and Non-Dairy Products and observe proportion of Product category.
with ProductCategories as ( 
       select item_id,
              item_name, 
              case 
              when item_iD in (3,4,5,8,9) then 'Dairy Products'
              else 'Non-Dairy Products'
              end as Product_Category
       from Items ;
    
select A.Product_Category, sum(quantity),
       sum(quantity* 100 / (select sum(quantity) from Invoices)) as percentage_sold
from ProductCategories A 
join Invoices B on A.item_id = B.item_id
group by product_category;


--5.Calculate total sale in day of week (Sunday to Saturday) .
select strftime('%w',A.order_date) as day_of_week, 
       sum(A.quantity*B.price) as Total_Sold
from Invoices A 
join Items B on A.item_id = B.item_id
group by day_of_week
order by day_of_week;


--6. Calculate total sale in day of week by Product category Dairy and Non dairy .
with ProductCategories as (
     select item_id,
            item_name, case 
                         when item_iD in (3,4,5,8,9) then 'Dairy Products'
                         else 'Non-Dairy Products'
                         end as Product_Category
from Items )

select A.Product_Category, strftime('%w',B.order_Date) as day_of_week,
       sum(B.quantity*C.price) as Total_Sold
from ProductCategories A
join Invoices B on A.item_id = B.item_id
join Items C on B.item_id = C.item_id
group by A.Product_Category,day_of_week;


--7. Calculate cumulative sale in day of week and Product category Dairy and Non dairy.
with cumulative as (
                    select strftime('%w',A.order_date) as day_of_week, 
                           sum(A.quantity*B.price) as Total_Sold
                    from Invoices A 
                    join Items B on A.item_id = B.item_id
                    group by day_of_week
                    order by day_of_week)

select * ,
       sum(Total_Sold) over(order by day_of_week) as cumulative_sale
from cumulative ;

