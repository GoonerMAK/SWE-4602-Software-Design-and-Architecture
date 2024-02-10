use kids_shop;

create table employee (
    id int not null auto_increment primary key,
    name varchar(100)
);

create table sale (
    id int not null auto_increment primary key,
    product_id int,
    invoice_id int,
    unit_price float not null,
    count int not null
);

create table invoice (
    id int not null auto_increment primary key,
    customer_id int,
    seller_id int,
    invoice_timestamp TIMESTAMP
);

ALTER TABLE sale
ADD CONSTRAINT fk_sale_product
FOREIGN KEY (product_id) REFERENCES product(id);

ALTER TABLE sale
ADD CONSTRAINT fk_sale_invoice_id
FOREIGN KEY (invoice_id) REFERENCES invoice(id);

ALTER TABLE invoice
ADD CONSTRAINT fk_invoice_customer
FOREIGN KEY (customer_id) REFERENCES customer(id);

ALTER TABLE invoice
ADD CONSTRAINT fk_invoice_employee
FOREIGN KEY (seller_id) REFERENCES employee(id);


INSERT INTO employee (name) VALUES ('AJ'), ('Sadik');

INSERT INTO invoice (customer_id, seller_id, invoice_timestamp) VALUES
(1, 1, '2024-02-10 08:00:00'),
(2, 1, '2024-02-10 09:30:00');

-- drop table employee;
-- drop table sale;
-- drop table invoice;
