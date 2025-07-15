use StoreDB

select 
count(product_id)
from production.products as [total number of products]


select
avg(list_price) 
from production.products  [avg of products]
select
min(list_price) 
from production.products  [min number of products]
select
max(list_price) 
from production.products  [max number of products]



select c.category_name ,
count(p.product_id) as product_count
from production.products p
inner join production.categories c
on c.category_id = p.category_id
group by c.category_name


select s.store_name ,
count(o.order_id) as order_count
from sales.orders o
inner join sales.stores s
on s.store_id = o.order_id
group by s.store_name



SELECT TOP  10
UPPER(first_name),
LOWER(last_name)
from sales.customers ;


SELECT TOP 10
len(product_name)  AS product_length,
product_name AS product_name
FROM
    production.products; 


select top 10  
customer_id,
phone,
left(phone  ,3) as area_code
from sales.customers  ;

SELECT --revition
    GETDATE() AS current_system_date,
    order_id,
    order_date,
    YEAR(order_date) AS order_year,  
    MONTH(order_date) AS order_month  
FROM
    Sales.Orders
WHERE
    order_id BETWEEN 1 AND 10;



select top 10 
p.product_name,
category_name
from production.products p
inner join production.categories c
on p.category_id=c.category_id


select top 10 
c.first_name + ' '+ c.last_name as full_name,
o.order_date
from sales.customers c
inner join sales.orders o
on o.customer_id = c.customer_id


select product_name, brand_name
from production.products p
left outer join production.brands b
on p.brand_id = b.brand_id


select product_name,p.list_price
from production.products p
where p.list_price> (select avg(p.list_price) from production.products p );


select c.first_name+' ' +c.last_name as full_name ,
c.customer_id
from sales.customers c
where c.customer_id
in (select c.customer_id from sales.orders) ;


SELECT
    c.customer_id, 
    c.first_name + ' ' + c.last_name AS customer_name, 
    (SELECT COUNT(o.order_id)                     
     FROM Sales.Orders o
     WHERE o.customer_id = c.customer_id) AS total_orders
FROM
    Sales.Customers c;


    
CREATE VIEW  easy_product_list AS 
     select customer_id, 
     first_name + ' ' + last_name AS full_name, 
     C.email, C.state +' '+ C.city AS CITY_STATE
    from Sales.Customers c





    SELECT p.product_name
    FROM production.products p
    where p.list_price between 50 and 200
    order by p.list_price ;

SELECT
    state,                       
    COUNT(customer_id) AS customer_count 
FROM
    Sales.Customers            
GROUP BY
    state                       
ORDER BY
    customer_count DESC;   
    



    
WITH RankedProducts AS (
    SELECT
        c.category_name,        
        p.product_name,         
        p.list_price,           
        ROW_NUMBER() OVER (PARTITION BY c.category_name ORDER BY p.list_price DESC) as rn
    FROM
        production.products p
    INNER JOIN
        production.categories c ON p.category_id = c.category_id
)
SELECT
    category_name,
    product_name,
    list_price
FROM
    RankedProducts
WHERE
    rn = 1;




SELECT
    s.store_name,                
    s.city,                      
    COUNT(o.order_id) AS order_count 
FROM
    Sales.Stores s              
LEFT JOIN
    Sales.Orders o ON s.store_id = o.store_id 
GROUP BY
    s.store_id, s.store_name, s.city 
order by
    order_count DESC;   
    
