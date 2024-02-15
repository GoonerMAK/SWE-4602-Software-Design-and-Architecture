
DROP PROCEDURE IF EXISTS Get_Top_Product_By_Category;
DELIMITER //
CREATE PROCEDURE Get_Top_Product_By_Category(IN category_id INT)
BEGIN
    SELECT id, name, category_id, average_rating, sale_count
    FROM fact_product
    WHERE category_id = category_id
    ORDER BY average_rating DESC
    LIMIT 1;
END //

DELIMITER ;

CALL Get_Top_Product_By_Category(1);