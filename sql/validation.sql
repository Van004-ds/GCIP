SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM sellers;
SELECT COUNT(*) FROM order_payments;
SELECT COUNT(*) FROM order_reviews;
SELECT COUNT(*) FROM geolocation;
SELECT COUNT(*) FROM product_category_name_translation;

-- primary key  validation cheking queries :
select count(*) as null_values from 
customers 
where customer_id is null;

select count(*) as null_values from 
products
where product_id is null;

select order_id,order_item_id, count(*)as null_val
from  order_items
group by  order_id,order_item_id
having count(*) >1;


select order_id, payment_sequential, count(*)as null_val
from  order_payments
group by   order_id, payment_sequential
having count(*) >1;
select review_id,order_id, count(*)as null_val
from   order_reviews
group by   review_id,order_id
having count(*) >1;



--foreign key validation cheking:
select count(*) as orphan_records
from orders o
left join customers c
on o.customer_id = c.customer_id
where c.customer_id is null ;

SELECT COUNT(*) AS orphan_items
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS orphan_products
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS orphan_sellers
FROM order_items oi
LEFT JOIN sellers s
ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

SELECT COUNT(*) AS orphan_payments
FROM order_payments op
LEFT JOIN orders o
ON op.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS orphan_reviews
FROM order_reviews r
LEFT JOIN orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

--data qualtity validation 
SELECT
COUNT(*) FILTER (WHERE customer_unique_id IS NULL) AS customer_unique_id_null,
COUNT(*) FILTER (WHERE customer_zip_code_prefix IS NULL) AS zip_null,
COUNT(*) FILTER (WHERE customer_city IS NULL) AS city_null,
COUNT(*) FILTER (WHERE customer_state IS NULL) AS state_null
FROM customers;


SELECT
COUNT(*) FILTER (WHERE order_status IS NULL) AS status_null,
COUNT(*) FILTER (WHERE order_purchase_timestamp IS NULL) AS purchase_null,
COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL) AS delivered_null
FROM orders;
--2965 ->order_delivered_customer_date ->Order may not be delivered yet or data is incomplete
-- or missing 

SELECT
COUNT(*) FILTER (WHERE product_category_name IS NULL) AS category_null,
COUNT(*) FILTER (WHERE product_weight_g IS NULL) AS weight_null
FROM products;
-- 610->product_category_name , 2->product_weight_g 
SELECT
COUNT(*) FILTER (WHERE review_comment_title IS NULL) AS title_null,
COUNT(*) FILTER (WHERE review_comment_message IS NULL) AS message_null
FROM order_reviews;
--87656 ->review_comment_title -> Customer may leave only a rating without a title or commented wihtout titile , 58247->review_comment_message->Customer may leave only a star rating(not commented).


-- Business rule validaion
SELECT *
FROM order_reviews
WHERE review_score NOT BETWEEN 1 AND 5;

SELECT *
FROM order_items
WHERE price < 0;


SELECT *
FROM order_items
WHERE freight_value < 0;
--fright vlaue is shipping price

SELECT *
FROM order_payments
WHERE payment_value < 0;

SELECT *
FROM order_payments
WHERE payment_installments <= 0;

-- -Found 2 records where payment_installments = 0. Since a completed payment should normally have at least one installment, these records may indicate a data quality issue or a special case in the source system. They should be flagged for further investigation rather than modified without business confirmation.
SELECT DISTINCT order_status
FROM orders;
--"shipped"
-- "unavailable"
-- "invoiced"
-- "created"
-- "approved"
-- "processing"
-- "delivered"
-- "canceled"