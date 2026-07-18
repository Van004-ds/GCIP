create table customers(
customer_id varchar(50) primary key,
customer_unique_id varchar(50) not null,
customer_zip_code_prefix int,
customer_city VARCHAR(100),
customer_state CHAR(2)
);

create Table products (
  product_id varchar(50) primary key ,
  product_category_name varchar(100),
  product_name_length int,
  product_description_length int,
  product_photos_qty int,
  product_weight_g int,
  product_length_cm int,
  product_height_cm int,
  product_width_cm int
);
create Table sellers (
  seller_id varchar(50) primary key ,
  seller_zip_code_prefix int,
  seller_city varchar(50),
  seller_state char(2)
);

create table orders (
  order_id varchar(50) primary key,
  customer_id varchar(50) references customers(customer_id),
  order_status varchar(50),
  order_purchase_timestamp timestamp ,
  order_approved_at timestamp,
  order_delivered_carrier_date timestamp,
  order_delivered_customer_date timestamp,
  order_estimated_delivery_date timestamp
);
create Table order_items (
  order_id varchar(50) references  orders(order_id),
 order_item_id int,
  product_id varchar(50) references products (product_id),
  seller_id varchar(50) references  sellers (seller_id),
  shipping_limit_date timestamp,
  price decimal(10,2),
  freight_value decimal(10,2),
  primary key(order_id , order_item_id )
);


create Table order_payments (
  order_id varchar(50) references orders(order_id),
  payment_sequential int ,
  payment_type varchar(50),
  payment_installments int,
  payment_value decimal(10,2),
  primary key(order_id ,  payment_sequential)
);
create Table order_reviews (
  review_id varchar(50) ,
  order_id varchar(50) references  orders(order_id),
  review_score int,
  review_comment_title varchar(50),
  review_comment_message text,
  review_creation_date timestamp,
  review_answer_timestamp timestamp ,
  PRIMARY KEY( review_id,order_id )
);
create Table geolocation (
  geolocation_zip_code_prefix int,
  geolocation_lat decimal(10,6),
  geolocation_lng decimal(10,6),
  geolocation_city varchar(50),
  geolocation_state varchar(50)
);
create Table product_category_name_translation (
  product_category_name varchar(50) primary key references products(product_category_name),
  product_category_name_english varchar(50)
  );
