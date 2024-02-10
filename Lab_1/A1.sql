use kids_shop;

create table customer (
    id int not null auto_increment primary key,
    name varchar(100),
    rating_timestamp TIMESTAMP
);

ALTER TABLE rating
ADD COLUMN customer_id int;

ALTER TABLE rating
ADD CONSTRAINT fk_rating_customer
FOREIGN KEY (customer_id) REFERENCES customer(id);

-- drop table customer;
