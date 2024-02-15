
DROP PROCEDURE IF EXISTS Get_Top_Product_by_Duration;
DELIMITER //
CREATE PROCEDURE Get_Top_Product_by_Duration(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT p.id, p.name, p.category_id, 
           (SELECT AVG(r.is_up_vote) 
            FROM fact_rating r 
            WHERE r.product_id = p.id 
              AND DATE(r.date_time) BETWEEN end_date AND start_date) AS average_rating
    FROM fact_product p
    ORDER BY average_rating DESC;
END //
DELIMITER ;

CALL Get_Top_Product_by_Duration('2024-02-15', '2024-02-07');
