
DROP PROCEDURE IF EXISTS Get_Top_Employee_By_Duration;
DELIMITER //
CREATE PROCEDURE Get_Top_Employee_By_Duration(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT e.id, e.name,
           (SELECT SUM(s.unit_price * s.count)
            FROM fact_sale s
            WHERE s.seller_id = e.id
              AND DATE(s.date_time) BETWEEN start_date AND end_date
           ) AS total_sales
    FROM dim_employee e
    ORDER BY total_sales DESC
    LIMIT 5;
END //

DELIMITER ;

CALL Get_Top_Employee_By_Duration('2024-02-07', '2024-02-15');
