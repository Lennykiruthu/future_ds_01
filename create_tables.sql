-- Create customers table
CREATE TABLE public.customers
(
    customer_id              VARCHAR(255) PRIMARY KEY,
    customer_unique_id       VARCHAR(255),
    customer_zip_code_prefix INT,
    customer_city            VARCHAR(255),              
    customer_state           VARCHAR(255)
);

-- Create orders table
CREATE TABLE public.orders
(
    order_id                       VARCHAR(255) PRIMARY KEY,
    customer_id                    VARCHAR(255),
    order_status                   VARCHAR(255),
    order_purchase_timestamp       TIMESTAMP,
    order_approved_at              TIMESTAMP,
    order_delivered_carrier_date   TIMESTAMP,
    order_delivered_customer_date  TIMESTAMP,
    order_estimated_delivery_date  TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id)
);

-- Create product category name translation table
CREATE TABLE public.product_categoty_name_translation
(
    product_category_name            VARCHAR(255) PRIMARY KEY,
    product_category_name_english    VARCHAR(255)
);

-- Create products table
CREATE TABLE public.products
(
    product_id                 VARCHAR(255) PRIMARY KEY,
    product_category_name      VARCHAR(255),
    product_name_length        FLOAT,
    product_description_length FLOAT,
    product_photos_qty         FLOAT,
    product_weight_g           FLOAT,
    product_length_cm          FLOAT,
    product_height_cm          FLOAT,
    product_width_cm           FLOAT,
    FOREIGN KEY (product_category_name) REFERENCES public.product_categoty_name_translation(product_category_name)  
);

-- Create sellers table
CREATE TABLE public.sellers
(
    seller_id               VARCHAR(255) PRIMARY KEY,
    seller_zip_code_prefix  INT,
    seller_city             VARCHAR(255),
    seller_state            VARCHAR(255)    
);

-- Create geological dataset
CREATE TABLE public.geological
(
    geolocation_zip_code_prefix  INT,
    geolocation_lat              FLOAT,
    geolocation_lng              FLOAT,
    geolocation_city             VARCHAR(255),
    geolocation_state            VARCHAR(255)
);

-- Create order items table
CREATE TABLE public.order_items
(
    order_id             VARCHAR(255),
    order_item_id        INT,
    product_id           VARCHAR(255),
    seller_id            VARCHAR(255),
    shipping_limit_date  TIMESTAMP,
    price                FLOAT,
    freight_value        FLOAT,
    PRIMARY KEY (order_id, order_item_id),    
    FOREIGN KEY (order_id) REFERENCES public.orders(order_id),
    FOREIGN KEY (product_id) REFERENCES public.products(product_id),
    FOREIGN KEY (seller_id) REFERENCES public.sellers(seller_id) 
);

-- Create order payments table
CREATE TABLE public.order_payments
(
    order_id              VARCHAR(255),
    payment_sequential    INT,
    payment_type          VARCHAR(255),
    payment_installments  INT,
    payment_value         FLOAT,
    FOREIGN KEY (order_id) REFERENCES public.orders(order_id)    
);

-- Create order reviews table
CREATE TABLE public.order_reviews
(
    review_id                VARCHAR(255),
    order_id                 VARCHAR(255),
    review_score             INT,
    review_comment_title     VARCHAR(255),
    review_comment_message   VARCHAR(255),
    review_creation_date     TIMESTAMP,
    review_answer_timestamp  TIMESTAMP,
    PRIMARY KEY(review_id, order_id),
    FOREIGN KEY (order_id) REFERENCES public.orders(order_id)     
);

-- Set ownership of all Olist tables to postgres
ALTER TABLE public.customers OWNER TO postgres;
ALTER TABLE public.orders OWNER TO postgres;
ALTER TABLE public.products OWNER TO postgres;
ALTER TABLE public.product_categoty_name_translation OWNER TO postgres;
ALTER TABLE public.sellers OWNER TO postgres;
ALTER TABLE public.geological OWNER TO postgres;
ALTER TABLE public.order_items OWNER TO postgres;
ALTER TABLE public.order_payments OWNER TO postgres;
ALTER TABLE public.order_reviews OWNER TO postgres;

-- Indexes for foreign key relationships
CREATE INDEX idx_orders_customer_id ON public.orders (customer_id);

CREATE INDEX idx_order_items_order_id ON public.order_items (order_id);
CREATE INDEX idx_order_items_product_id ON public.order_items (product_id);
CREATE INDEX idx_order_items_seller_id ON public.order_items (seller_id);

CREATE INDEX idx_order_payments_order_id ON public.order_payments (order_id);

CREATE INDEX idx_order_reviews_order_id ON public.order_reviews (order_id);

-- Populate customers table with csv data
COPY customers
FROM 'D:/local-git-repos/brazillian-ecommerce-analysis/olist_customers_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Populate orders table with csv data
COPY orders
FROM 'D:/local-git-repos/brazillian-ecommerce-analysis/olist_orders_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Populate orders table with csv data
COPY product_categoty_name_translation
FROM 'D:/local-git-repos/brazillian-ecommerce-analysis/product_category_name_translation.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Populate orders table with csv data
COPY products
FROM 'D:/local-git-repos/brazillian-ecommerce-analysis/olist_products_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Populate orders table with csv data
COPY sellers
FROM 'D:/local-git-repos/brazillian-ecommerce-analysis/olist_sellers_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Populate orders table with csv data
COPY geological
FROM 'D:/local-git-repos/brazillian-ecommerce-analysis/olist_geolocation_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Populate orders table with csv data
COPY order_items
FROM 'D:/local-git-repos/brazillian-ecommerce-analysis/olist_order_items_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Populate orders table with csv data
COPY order_payments
FROM 'D:/local-git-repos/brazillian-ecommerce-analysis/olist_order_payments_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

-- Populate orders table with csv data
COPY order_reviews
FROM 'D:/local-git-repos/brazillian-ecommerce-analysis/olist_order_reviews_dataset.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');