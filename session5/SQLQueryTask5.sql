SELECT 
    product_id,
    product_name,
    list_price,
    CASE 
        WHEN list_price < 300 THEN 'Economy'
        WHEN list_price BETWEEN 300 AND 999 THEN 'Standard'
        WHEN list_price BETWEEN 1000 AND 2499 THEN 'Premium'
        ELSE 'Luxury'
    END AS price_category
FROM production.products;




SELECT 
    order_id,
    customer_id,
    order_status,
    order_date,
    CASE order_status
        WHEN 1 THEN 'Order Received'
        WHEN 2 THEN 'In Preparation'
        WHEN 3 THEN 'Order Cancelled'
        WHEN 4 THEN 'Order Delivered'
    END AS status_description,
    CASE 
        WHEN order_status = 1 AND DATEDIFF(DAY, order_date, GETDATE()) > 5 THEN 'URGENT'
        WHEN order_status = 2 AND DATEDIFF(DAY, order_date, GETDATE()) > 3 THEN 'HIGH'
        ELSE 'NORMAL'
    END AS priority_level
FROM sales.orders;



SELECT 
    s.staff_id,
    s.first_name + ' ' + s.last_name AS staff_name,
    COUNT(o.order_id) AS order_count,
    CASE 
        WHEN COUNT(o.order_id) = 0 THEN 'New Staff'
        WHEN COUNT(o.order_id) BETWEEN 1 AND 10 THEN 'Junior Staff'
        WHEN COUNT(o.order_id) BETWEEN 11 AND 25 THEN 'Senior Staff'
        ELSE 'Expert Staff'
    END AS staff_level
FROM sales.staffs s
LEFT JOIN sales.orders o ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name;





SELECT 
    customer_id,
    first_name,
    last_name,
    ISNULL(phone, 'Phone Not Available') AS phone,
    email,
    COALESCE(phone, email, 'No Contact Method') AS preferred_contact
FROM sales.customers;





SELECT 
    p.product_id,
    p.product_name,
    s.quantity,
    ISNULL(p.list_price / NULLIF(s.quantity, 0), 0) AS price_per_unit,
    CASE 
        WHEN s.quantity > 0 THEN 'In Stock'
        ELSE 'Out of Stock'
    END AS stock_status
FROM production.products p
JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.store_id = 1;




SELECT 
    customer_id,
    COALESCE(street, '') + ', ' + COALESCE(city, '') + ', ' + 
    COALESCE(state, '') + ', ' + COALESCE(zip_code, '') AS formatted_address
FROM sales.customers;






WITH customer_spending AS (
    SELECT 
        o.customer_id,
        SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS total_spent
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT c.*, cs.total_spent
FROM sales.customers c
JOIN customer_spending cs ON c.customer_id = cs.customer_id
WHERE cs.total_spent > 1500
ORDER BY cs.total_spent DESC;





WITH revenue_per_category AS (
    SELECT p.category_id, SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS total_revenue
    FROM sales.order_items oi
    JOIN production.products p ON oi.product_id = p.product_id
    GROUP BY p.category_id
),
avg_order_value AS (
    SELECT p.category_id, AVG(oi.list_price * oi.quantity * (1 - oi.discount)) AS avg_order_value
    FROM sales.order_items oi
    JOIN production.products p ON oi.product_id = p.product_id
    GROUP BY p.category_id
)
SELECT c.category_name, r.total_revenue, a.avg_order_value,
    CASE 
        WHEN r.total_revenue > 50000 THEN 'Excellent'
        WHEN r.total_revenue > 20000 THEN 'Good'
        ELSE 'Needs Improvement'
    END AS performance
FROM revenue_per_category r
JOIN avg_order_value a ON r.category_id = a.category_id
JOIN production.categories c ON r.category_id = c.category_id;





WITH monthly_sales AS (
    SELECT 
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS total_sales
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY YEAR(order_date), MONTH(order_date)
),
sales_with_lag AS (
    SELECT *, LAG(total_sales) OVER (ORDER BY year, month) AS prev_month_sales
    FROM monthly_sales
)
SELECT *, 
    ROUND(CASE 
        WHEN prev_month_sales IS NULL THEN NULL
        ELSE 100.0 * (total_sales - prev_month_sales) / prev_month_sales
    END, 2) AS growth_percentage
FROM sales_with_lag;






SELECT *
FROM (
    SELECT 
        p.product_id, p.product_name, p.category_id, p.list_price,
        ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS rn,
        RANK() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS rnk,
        DENSE_RANK() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS drnk
    FROM production.products p
) ranked
WHERE rn <= 3;






WITH customer_spending AS (
    SELECT o.customer_id, SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS total_spent
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
)
SELECT *,
    RANK() OVER (ORDER BY total_spent DESC) AS spending_rank,
    NTILE(5) OVER (ORDER BY total_spent DESC) AS spending_group,
    CASE NTILE(5) OVER (ORDER BY total_spent DESC)
        WHEN 1 THEN 'VIP'
        WHEN 2 THEN 'Gold'
        WHEN 3 THEN 'Silver'
        WHEN 4 THEN 'Bronze'
        ELSE 'Standard'
    END AS tier
FROM customer_spending;




WITH store_performance AS (
    SELECT 
        o.store_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.list_price * oi.quantity * (1 - oi.discount)) AS total_revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY o.store_id
)
SELECT *,
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    RANK() OVER (ORDER BY total_orders DESC) AS order_rank,
    PERCENT_RANK() OVER (ORDER BY total_revenue) AS revenue_percentile
FROM store_performance;



SELECT *
FROM (
    SELECT 
        c.category_name,
        b.brand_name,
        p.product_id
    FROM production.products p
    JOIN production.categories c ON p.category_id = c.category_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    WHERE b.brand_name IN ('Electra', 'Haro', 'Trek', 'Surly')
) AS SourceTable
PIVOT (
    COUNT(product_id) FOR brand_name IN ([Electra], [Haro], [Trek], [Surly])
) AS PivotTable;



SELECT *, 
    ISNULL([Jan], 0) + ISNULL([Feb], 0) + ISNULL([Mar], 0) + ISNULL([Apr], 0) +
    ISNULL([May], 0) + ISNULL([Jun], 0) + ISNULL([Jul], 0) + ISNULL([Aug], 0) +
    ISNULL([Sep], 0) + ISNULL([Oct], 0) + ISNULL([Nov], 0) + ISNULL([Dec], 0) AS Total
FROM (
    SELECT 
        s.store_name,
        DATENAME(MONTH, o.order_date) AS order_month,
        oi.quantity * oi.list_price * (1 - oi.discount) AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN sales.stores s ON o.store_id = s.store_id
) AS SourceTable
PIVOT (
    SUM(revenue) FOR order_month IN (
        [Jan], [Feb], [Mar], [Apr], [May], [Jun],
        [Jul], [Aug], [Sep], [Oct], [Nov], [Dec]
    )
) AS PivotTable;



SELECT *
FROM (
    SELECT 
        s.store_name,
        CASE o.order_status
            WHEN 1 THEN 'Pending'
            WHEN 2 THEN 'Processing'
            WHEN 3 THEN 'Rejected'
            WHEN 4 THEN 'Completed'
        END AS status_label
    FROM sales.orders o
    JOIN sales.stores s ON o.store_id = s.store_id
) AS SourceTable
PIVOT (
    COUNT(status_label) FOR status_label IN ([Pending], [Processing], [Completed], [Rejected])
) AS PivotTable;




WITH yearly_sales AS (
    SELECT 
        b.brand_name,
        YEAR(o.order_date) AS sales_year,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
    FROM sales.order_items oi
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    JOIN sales.orders o ON o.order_id = oi.order_id
    WHERE YEAR(o.order_date) IN (2016, 2017, 2018)
    GROUP BY b.brand_name, YEAR(o.order_date)
)
SELECT *,
    ROUND((ISNULL([2017], 0) - ISNULL([2016], 0)) * 100.0 / NULLIF([2016], 0), 2) AS Growth_2017,
    ROUND((ISNULL([2018], 0) - ISNULL([2017], 0)) * 100.0 / NULLIF([2017], 0), 2) AS Growth_2018
FROM yearly_sales
PIVOT (
    SUM(total_revenue) FOR sales_year IN ([2016], [2017], [2018])
) AS PivotTable;






-- In-stock products
SELECT p.product_id, p.product_name, 'In Stock' AS status
FROM production.products p
JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.quantity > 0

UNION

-- Out-of-stock products
SELECT p.product_id, p.product_name, 'Out of Stock'
FROM production.products p
JOIN production.stocks s ON p.product_id = s.product_id
WHERE s.quantity = 0 OR s.quantity IS NULL

UNION

-- Discontinued products (not in stock table)
SELECT p.product_id, p.product_name, 'Discontinued'
FROM production.products p
WHERE NOT EXISTS (
    SELECT 1 FROM production.stocks s WHERE s.product_id = p.product_id
);





SELECT customer_id
FROM sales.orders
WHERE YEAR(order_date) = 2017
INTERSECT
SELECT customer_id
FROM sales.orders
WHERE YEAR(order_date) = 2018;



SELECT product_id, 'Available in All Stores' AS availability
FROM production.stocks
WHERE store_id = 1
INTERSECT
SELECT product_id FROM production.stocks WHERE store_id = 2
INTERSECT
SELECT product_id FROM production.stocks WHERE store_id = 3

UNION


SELECT product_id, 'Only in Store 1'
FROM production.stocks
WHERE store_id = 1
EXCEPT
SELECT product_id FROM production.stocks WHERE store_id = 2;




SELECT customer_id, 'Lost Customer' AS status
FROM sales.orders
WHERE YEAR(order_date) = 2016
EXCEPT
SELECT customer_id FROM sales.orders WHERE YEAR(order_date) = 2017

UNION ALL





SELECT customer_id, 'New Customer'
FROM sales.orders
WHERE YEAR(order_date) = 2017
EXCEPT
SELECT customer_id FROM sales.orders WHERE YEAR(order_date) = 2016

UNION ALL


SELECT customer_id, 'Retained Customer'
FROM sales.orders
WHERE YEAR(order_date) = 2016
INTERSECT
SELECT customer_id FROM sales.orders WHERE YEAR(order_date) = 2017;



