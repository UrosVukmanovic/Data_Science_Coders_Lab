#DAY 4 SQL BASICS

#CONDITIONAL EXPRESIONS (IF ELSEIF CASE)

/*
    Actors ratings
    Using the actor_analyticstable write a query that groups actors according to the following criteria:

    if avg_film_rate < 2 - 'poor acting',
    if avg_film_rate is between 2 and 2.5 - 'fair acting',
    if avg_film_rate is between 2.5 and 3.5 - 'good acting',
    if avg_film_rate is above 3.5 - 'superb acting.
    Call the column created this way: acting_level and use it in an analysis that calculates:

    number of occurrences in each group,
    the total revenue of each group,
    number of films in each group,
    the average rating in a group.
    Hint: Do the exercise in two steps:

    Write a subquery that creates an acting_level column,
    Based on the results from the previous subpoint, do the rest of the exercise.
 */

WITH rated_actors AS (
    SELECT
        *,
    CASE
            WHEN aa.avg_film_rate < 2 THEN 'poor acting'
            WHEN aa.avg_film_rate >= 2 AND aa.avg_film_rate < 2.5 THEN 'fair acting'
            WHEN aa.avg_film_rate >= 2.5 AND aa.avg_film_rate <= 3.5 THEN 'good acting'
            WHEN aa.avg_film_rate > 3.5 THEN 'superb acting'
        END AS acting_level
FROM sakila4_169.actor_analytics AS aa
)
SELECT
    acting_level,
    COUNT(*) AS actor_count,
    ROUND(AVG(avg_film_rate), 2) AS avg_group_rating,
    SUM(actor_payload) AS total_sum_per_group,
    SUM(films_amount) AS total_films_per_group
FROM rated_actors
GROUP BY acting_level
ORDER BY avg_group_rating;

/*
    Film duration
    Write a procedure that, based on the duration of the film (i.e. length column from film), assigns the record to one of the groups below:

    very short - film up to 1h,
    short - film up to 1.5h,
    normal - film up to 2h,
    long - film up to 2.5h,
    very long - film over 2.5h.
    Call the procedure film_classification.

    Hint:

    In this exercise, for now, we will not query any table. We will pass film duration as a procedure parameter.
 */

DELIMITER $$

CREATE PROCEDURE film_duration(IN length DOUBLE)
BEGIN
    IF length <= 60 THEN
        SELECT 'very short';
    ELSEIF length <= 90 THEN
        SELECT 'short';
    ELSEIF length <= 120 THEN
        SELECT 'normal';
    ELSEIF length <= 150 THEN
        SELECT 'long';
    ELSE
        SELECT 'very long';
    END IF;
END;$$


CALL film_duration(180);

/*
    Payment amount
Write a query that groups the payments according to the following classification:

fee - payments below 2,
regular - all others.
Use the payment table to complete the exercise.

Group the result and use SQL to find out what percent of the total payments were the fees.
 */

WITH cte_pay_amount AS(
    SELECT
        *,
    CASE
        WHEN aa.amount < 2 THEN 'fee'
        WHEN aa.amount >= 2 THEN 'all others'
    END AS payment_amount
    FROM sakila4_169.payment AS aa
),
cte_by_pa AS(
SELECT
    cpa.payment_amount,
    COUNT(*) AS br_redova
FROM cte_pay_amount AS cpa
GROUP BY cpa.payment_amount
)
SELECT
    payment_amount,
    br_redova,
    SUM(br_redova) OVER () AS total_rows,
   ROUND(br_redova / SUM(br_redova) OVER (), 2) as pct
FROM cte_by_pa;

#TRANSACTIONS

/*
    Film rental
    Based on the analogy with a bank transaction, write a film_rental procedure that uses the table
    trigger_exercise.stock_part_1 to check whether a given film_id can be rented -
    if so, reduce the stock by one and return 1, otherwise return 0.

    Example of use:

    CALL film_rental(1)

    Take advantage of the transaction mechanism here by following the steps below:

    First write a query that finds the film and reduces its stock by 1,
    If the film is found and its count is sufficient to be rented, approve the transaction.
    Otherwise, cancel it.
*/

SELECT
    *
FROM trigger_exercise4_169.stock_part_1;

DROP PROCEDURE IF EXISTS film_rental;

DELIMITER $$
CREATE PROCEDURE film_rental(IN p_film_id INT)
BEGIN
    DECLARE stock_remaining INT;
    START TRANSACTION;
    UPDATE trigger_exercise4_169.stock_part_1
    SET stock = stock - 1
    WHERE film_id = p_film_id AND stock > 0;
    SELECT stock
    INTO stock_remaining
    FROM trigger_exercise4_169.stock_part_1
    WHERE film_id = p_film_id;

    IF ROW_COUNT() > 0 THEN
        COMMIT;
        SELECT 1 AS result,
               stock_remaining;
    ELSE
        ROLLBACK;
        SELECT 0 AS result,
               stock_remaining;
    END IF;
END;
$$
DELIMITER ;

SELECT
    *
FROM trigger_exercise4_169.stock_part_1;

CALL film_rental(50);

# LOOPS

/*
    Multiplication
    Create a database procedure with a name of your choice that for the parameters:
    base and number_of_elements returns the multiple of base equal to the number of elements.

    For example:

    -- calling a procedure with base 2 and number of elements 10
    CALL proc_name(@p_base:=2, @p_number:=10)

    -- Result:
    -- 2,4,6,8,10,12,14,16,18,20

    Note:

    In order to combine a string and a numeric type, you can take a hint from the following code snippet:
*/
# 1 SOLUTION FOR LOOP

DELIMITER $$
DROP PROCEDURE IF EXISTS multiplication;
CREATE PROCEDURE multiplication(
    IN p_base INT,
    IN p_number INT
)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE result_str VARCHAR(1000) DEFAULT '';

    loop_label: LOOP
        IF i > p_number THEN
            LEAVE loop_label;
        END IF;

        SET result_str = CONCAT(result_str, p_base * i);

        IF i < p_number THEN
            SET result_str = CONCAT(result_str, ',');
        END IF;

        SET i = i + 1;
    END LOOP;

    SELECT result_str;
END$$

DELIMITER ;

CALL multiplication(3, 5);

# 2 SOLUTION WHILE LOOP

DELIMITER $$
DROP PROCEDURE IF EXISTS multiplication;
CREATE PROCEDURE multiplication(IN p_base INT, IN p_number INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE str VARCHAR(255) DEFAULT '';

    WHILE i <= p_number DO
        SET str = CONCAT(str, p_base * i);
        IF i < p_number THEN
            SET str = CONCAT(str, ',');
        END IF;
        SET i = i + 1;
    END WHILE;

    SELECT str;
END; $$
DELIMITER ;

CALL multiplication(3, 5);

#CURSOR
/*
    Newsletter
    Write a procedure using cursors that for active clients from the Buenos Aires area returns the email to send the newsletter to.

    Separate elements with ;.

    Hint: Data needed to do it are in the customer and address tables.
*/

