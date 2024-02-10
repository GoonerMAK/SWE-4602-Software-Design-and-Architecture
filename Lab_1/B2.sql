
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
