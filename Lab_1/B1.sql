use kids_shop;

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

