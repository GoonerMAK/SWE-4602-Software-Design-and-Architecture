
DROP PROCEDURE IF EXISTS Get_Top_Rated_Categories
DELIMITER //
CREATE PROCEDURE Get_Top_Rated_Categories()
BEGIN
    SELECT id, name, average_rating
    FROM dim_category
    ORDER BY average_rating DESC
    LIMIT 2;
END //
DELIMITER ;

CALL Get_Top_Rated_Categories();
