USE StoreDB

select * from production.products
where list_price >1000
order by list_price;

select * from sales.customers
where state IN ('CA' , 'NY' );

select * from sales.orders 
where order_date = 2023;      --error because the datatype 

select * from sales.customers
where email like '%@gmail.com';

select * from sales.staffs
where active ='0';

select top 3 product_name
from production.products
order by list_price desc ;

select top 10 * 
from sales.orders
order by orders.order_date desc;

select top 3 last_name
from sales.customers
order by last_name ;


select * from sales.customers
where phone is null; 

select * from sales.staffs
where manager_id is not null; 

select * from production.products 
where list_price between 499 and 1501;

select city
from sales.customers
where city like 's%';


select *
from sales.orders
where order_status in (2 , 4 );


select *
from production.products 
where category_id in (1 ,2 ,3 );

select *
from sales.staffs
where store_id = 1 or store_id is null ;

select count(*)
from production.products
group by category_id;

select count(*)
from sales.customers
group by state;

select avg(list_price)
from production.products
group by brand_id;

select count(*)
from sales.orders
group by staff_id;




