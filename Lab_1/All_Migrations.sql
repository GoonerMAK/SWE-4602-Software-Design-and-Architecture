use kids_shop;


ALTER TABLE vote RENAME rating; 

ALTER TABLE rating    
MODIFY is_up_vote INTEGER;  

ALTER TABLE product CHANGE COLUMN 
votes average_rating FLOAT NOT NULL;

ALTER TABLE product
ADD CONSTRAINT fk_product_category
FOREIGN KEY (category_id) REFERENCES category(id);

ALTER TABLE rating
ADD CONSTRAINT fk_rating_product
FOREIGN KEY (product_id) REFERENCES product(id);


DROP PROCEDURE IF EXISTS updateRatingValues;
DELIMITER //
CREATE PROCEDURE updateRatingValues()
BEGIN
    UPDATE rating
    SET is_up_vote = CASE
        WHEN is_up_vote = 0 THEN 1
        WHEN is_up_vote = 1 THEN 5
        ELSE is_up_vote
    END;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS recalculate_average_product_ratings;
DELIMITER //
create procedure recalculate_average_product_ratings()
begin
    update product p
        set average_rating = 
        (SELECT AVG(is_up_vote)
        FROM rating r
        WHERE r.product_id = p.id)
           
    where 1 = 1;
end;//
DELIMITER ;

CALL updateRatingValues();
CALL recalculate_average_product_ratings();


create table customer (
    id int not null auto_increment primary key,
    name varchar(100),
    rating_timestamp TIMESTAMP
);

ALTER TABLE rating
ADD COLUMN customer_id int not null;

ALTER TABLE rating
ADD CONSTRAINT fk_rating_customer
FOREIGN KEY (customer_id) REFERENCES customer(id);

-- drop table customer;


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


INSERT INTO customer (name, rating_timestamp) VALUES 
('MAK', '2024-02-10 08:00:00'),
('SAM', '2024-02-09 15:30:00');

DROP PROCEDURE IF EXISTS add_rating;
DELIMITER //
CREATE PROCEDURE add_rating(
    IN p_product_id INT,
    IN p_is_up_vote INT,
    IN p_customer_id INT
)
BEGIN
    DECLARE v_rating_id INT;

    INSERT INTO rating (product_id, is_up_vote, customer_id)
    VALUES (p_product_id, p_is_up_vote, p_customer_id);
END //
DELIMITER ;

CALL add_rating(4, 5, 1);
CALL recalculate_average_product_ratings();



DROP PROCEDURE IF EXISTS get_average_rating;
DELIMITER //
CREATE PROCEDURE get_average_rating(
    IN p_product_id INT,
    OUT p_average_rating FLOAT
)
BEGIN
    SELECT average_rating INTO p_average_rating
    FROM product
    WHERE id = p_product_id;
END //
DELIMITER ;

CALL get_average_rating(1, @p_average_rating);
SELECT @p_average_rating;



ALTER TABLE category
ADD COLUMN average_rating FLOAT;

DROP PROCEDURE IF EXISTS calculate_average_category_ratings;
DELIMITER //
create procedure calculate_average_category_ratings()
begin
    update category c
        set c.average_rating = 
        (SELECT AVG(p.average_rating)
        FROM product p
        WHERE p.category_id = c.id)
           
    where 1 = 1;
end;//
DELIMITER ;

CALL calculate_average_category_ratings();


ALTER TABLE sale
ADD COLUMN category_id int,
ADD CONSTRAINT fk_sale_category
FOREIGN KEY (category_id) REFERENCES category(id);

ALTER TABLE sale
ADD COLUMN seller_id int,
ADD CONSTRAINT fk_sale_employee
FOREIGN KEY (seller_id) REFERENCES employee(id);

ALTER TABLE sale
ADD COLUMN date_time TIMESTAMP;

ALTER TABLE sale
ADD COLUMN date_time TIMESTAMP;         -- Procedure needed to update the values of the column 

ALTER TABLE product
ADD COLUMN sale_count int;              -- Procedure needed to update the values of the column 

ALTER TABLE category
ADD COLUMN total_sale FLOAT;            -- Procedure needed to update the values of the column 


INSERT INTO sale (product_id, invoice_id, unit_price, count, category_id, seller_id, date_time) VALUES
(1, 1, 10.99, 2, 1, 1, '2024-02-10 08:15:00'),
(2, 2, 15.75, 1, 2, 2, '2024-02-10 09:45:00'),
(3, 1, 5.50, 3, 1, 1, '2024-02-10 11:00:00'),
(3, 1, 15.99, 1, 2, 1, '2024-02-10 19:55:00');


DROP PROCEDURE IF EXISTS get_sale_per_category;
DELIMITER //
CREATE PROCEDURE get_sale_per_category(
    IN p_employee_id INT
)
BEGIN
    SELECT category_id, SUM(unit_price * count) AS total_sales
    FROM sale
    WHERE seller_id = p_employee_id
    GROUP BY category_id;
    
END //
DELIMITER ;

CALL get_sale_per_category(1);


DROP PROCEDURE IF EXISTS set_product_category;
DELIMITER //
CREATE PROCEDURE set_product_category(
    IN p_product_id INT,
    IN p_category_id INT
)
BEGIN
    UPDATE product
    SET category_id = p_category_id
    WHERE id = p_product_id;
END //
DELIMITER ;

CALL set_product_category(1, 1);
