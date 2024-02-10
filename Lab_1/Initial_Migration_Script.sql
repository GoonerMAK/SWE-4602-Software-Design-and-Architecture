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



