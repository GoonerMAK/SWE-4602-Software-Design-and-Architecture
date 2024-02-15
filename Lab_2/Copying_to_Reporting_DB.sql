-- DROP DATABASE IF EXISTS reporting_kids_shop;

CREATE DATABASE IF NOT EXISTS reporting_kids_shop;
use reporting_kids_shop;

CREATE TABLE dim_change_log LIKE kids_shop.change_log;

CREATE TABLE dim_category LIKE kids_shop.category;

CREATE TABLE dim_customer LIKE kids_shop.customer;

CREATE TABLE dim_employee LIKE kids_shop.employee;

CREATE TABLE fact_product LIKE kids_shop.product;

CREATE TABLE fact_invoice LIKE kids_shop.invoice;

CREATE TABLE fact_rating LIKE kids_shop.rating;

CREATE TABLE fact_sale LIKE kids_shop.sale;


INSERT INTO change_log SELECT * FROM kids_shop.change_log;

INSERT INTO dim_category SELECT * FROM kids_shop.category;

INSERT INTO dim_customer SELECT * FROM kids_shop.customer;

INSERT INTO dim_employee SELECT * FROM kids_shop.employee;

INSERT INTO fact_product SELECT * FROM kids_shop.product;

INSERT INTO fact_invoice SELECT * FROM kids_shop.invoice;

INSERT INTO fact_rating SELECT * FROM kids_shop.rating;

INSERT INTO fact_sale SELECT * FROM kids_shop.sale;


ALTER TABLE fact_product
ADD CONSTRAINT fk_product_category
FOREIGN KEY (category_id) REFERENCES dim_category(id);

ALTER TABLE fact_rating
ADD CONSTRAINT fk_rating_product
FOREIGN KEY (product_id) REFERENCES fact_product(id);

ALTER TABLE fact_rating
ADD CONSTRAINT fk_rating_customer
FOREIGN KEY (customer_id) REFERENCES dim_customer(id);

ALTER TABLE fact_sale
ADD CONSTRAINT fk_sale_product
FOREIGN KEY (product_id) REFERENCES fact_product(id);

ALTER TABLE fact_sale
ADD CONSTRAINT fk_sale_invoice_id
FOREIGN KEY (invoice_id) REFERENCES fact_invoice(id);

ALTER TABLE fact_invoice
ADD CONSTRAINT fk_invoice_customer
FOREIGN KEY (customer_id) REFERENCES dim_customer(id);

ALTER TABLE fact_invoice
ADD CONSTRAINT fk_invoice_employee
FOREIGN KEY (seller_id) REFERENCES dim_employee(id);

ALTER TABLE fact_sale
ADD CONSTRAINT fk_sale_category
FOREIGN KEY (category_id) REFERENCES dim_category(id);

ALTER TABLE fact_sale
ADD CONSTRAINT fk_sale_employee
FOREIGN KEY (seller_id) REFERENCES dim_employee(id);