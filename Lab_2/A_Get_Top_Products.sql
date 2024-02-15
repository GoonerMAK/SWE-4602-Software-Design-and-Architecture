
DROP PROCEDURE IF EXISTS Get_Top_Rated_Products
DELIMITER //
CREATE PROCEDURE IF EXISTS Get_Top_Rated_Products()
BEGIN
    SELECT id, name, category_id, average_rating, sale_count
    FROM product
    ORDER BY average_rating DESC
    LIMIT 3;
END //
DELIMITER ;

CALL Get_Top_Rated_Products();
