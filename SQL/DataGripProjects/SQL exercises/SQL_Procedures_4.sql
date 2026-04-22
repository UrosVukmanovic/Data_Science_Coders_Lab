#DAY 4 SQL BASICS

#CONDITIONAL EXPRESSIONS (IF ELSEIF CASE)

/*
    Actors ratings
    Using the actor_analyticstable write a query that groups actors according to the following criteria:

    if avg_film_rate < 2 - 'poor acting',
    if avg_film_rate is between 2 and 2.5 - 'fair acting',
    if avg_film_rate is between 2.5 and 3.5 - 'good acting',
    if avg_film_rate is above 3.5 - 'superb acting'.
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
    DECLARE affected_rows INT;
    DECLARE stock_remaining INT;

    START TRANSACTION;

    UPDATE trigger_exercise4_169.stock_part_1
    SET stock = stock - 1
    WHERE film_id = p_film_id
      AND stock > 0;

    SET affected_rows = ROW_COUNT();

    IF affected_rows = 1 THEN
        SELECT stock
        INTO stock_remaining
        FROM trigger_exercise4_169.stock_part_1
        WHERE film_id = p_film_id;

        COMMIT;

        SELECT 1 AS result,
               stock_remaining;
    ELSE
        ROLLBACK;

        SELECT 0 AS result,
               NULL AS stock_remaining;
    END IF;
END$$

DELIMITER ;

SELECT
    *
FROM trigger_exercise4_169.stock_part_1;

CALL film_rental(7);

/*
    Film rentals 2
    Write a procedure film_rental_store that tests if it is possible
    to rent the film at the given store (stock_part_2 table).

If possible (the film is available), the procedure should:

return the information about the stock after renting the film
and the information that the film is available to rent.
Otherwise, the procedure should:

return the information that the film is out of stock in the store,
return the information whether the film can be rented from another store.
If so, make a reservation there, that is: reduce the stock.
What parameters does the procedure need to take to be executed?

You may use this. Additionally, offer a different solution.

Hint:

The stock is updated by removing the appropriate record from the table;
remember to start a transaction before DELETE.
*/

SELECT
    *
FROM trigger_exercise4_169.stock_part_2
WHERE stock_part_2.store_id = 2;

DROP PROCEDURE IF EXISTS film_rental_store;

DELIMITER $$

CREATE PROCEDURE film_rental_store(
    IN p_film_id INT,
    IN p_store_id INT
)
BEGIN
    DECLARE v_other_store_id INT;
    DECLARE v_stock_remaining INT;
    DECLARE v_deleted_rows INT;

    START TRANSACTION;

    DELETE FROM trigger_exercise4_169.stock_part_2
    WHERE film_id = p_film_id
      AND store_id = p_store_id
    LIMIT 1;

    SET v_deleted_rows = ROW_COUNT();

    IF v_deleted_rows = 1 THEN
        SELECT COUNT(*)
        INTO v_stock_remaining
        FROM trigger_exercise4_169.stock_part_2
        WHERE film_id = p_film_id
          AND store_id = p_store_id;

        COMMIT;

        SELECT
            1 AS result,
            'Film is available in requested store and has been rented.' AS message,
            p_store_id AS rented_from_store,
            v_stock_remaining AS stock_remaining_in_store;
    ELSE
        SELECT MIN(store_id)
        INTO v_other_store_id
        FROM trigger_exercise4_169.stock_part_2
        WHERE film_id = p_film_id
          AND store_id <> p_store_id;

        IF v_other_store_id IS NOT NULL THEN
            DELETE FROM trigger_exercise4_169.stock_part_2
            WHERE film_id = p_film_id
              AND store_id = v_other_store_id
            LIMIT 1;

            SELECT COUNT(*)
            INTO v_stock_remaining
            FROM trigger_exercise4_169.stock_part_2
            WHERE film_id = p_film_id
              AND store_id = v_other_store_id;

            COMMIT;

            SELECT
                2 AS result,
                'Film is out of stock in requested store, but was reserved in another store.' AS message,
                v_other_store_id AS reserved_from_store,
                v_stock_remaining AS stock_remaining_in_other_store;
        ELSE
            ROLLBACK;

            SELECT
                0 AS result,
                'Film is out of stock in requested store and unavailable in other stores.' AS message,
                NULL AS reserved_from_store,
                NULL AS stock_remaining_in_other_store;
        END IF;
    END IF;
END$$

DELIMITER ;

CALL film_rental_store(2, 7);

# LOOPS

/*
    Multiplication
    Create a database procedure with a name of your choice that for the parameters:
    base and number_of_elements returns the multiple of base equal to the
    number of elements.

    For example:

    -- calling a procedure with base 2 and number of elements 10
    CALL proc_name(@p_base:=2, @p_number:=10)

    -- Result:
    -- 2,4,6,8,10,12,14,16,18,20
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

/*
    Randomization
Write a procedure that first creates a table called randomizer, and then fills it with random values (a part of the procedure should be to specify how many values should be in the table). For example:

CALL fill_randomizer(10)

should populate the randomizer table with 10 random values from the 0-1 range.
 */

DROP PROCEDURE IF EXISTS fill_randomizer;

DELIMITER $$

CREATE PROCEDURE fill_randomizer(IN p_count INT)
BEGIN
    DECLARE i INT DEFAULT 1;

    DROP TABLE IF EXISTS randomizer;

    CREATE TABLE randomizer (
        id INT,
        value FLOAT
    );

    WHILE i <= p_count DO
        INSERT INTO randomizer (id, value)
        VALUES (i, RAND());

        SET i = i + 1;
    END WHILE;

END $$

DELIMITER ;

CALL trigger_exercise4_169.fill_randomizer(10);

SELECT
    *
FROM trigger_exercise4_169.randomizer;

DROP PROCEDURE IF EXISTS fill_randomizer_2;

DELIMITER $$
CREATE PROCEDURE fill_randomizer_2(IN p2_count INT)
BEGIN
    DECLARE i INT DEFAULT 1;

    DROP TABLE IF EXISTS randomizer_2;

    CREATE TABLE randomizer_2(
        id INT,
        value FLOAT
    );
    WHILE i <= p2_count DO
        INSERT INTO randomizer_2 (id, value)
            VALUES( i, RAND());
        SET i = i + 1;
    END WHILE ;
END $$
DELIMITER ;

CALL fill_randomizer_2(15);

SELECT
    *
FROM trigger_exercise4_169.randomizer_2;

#CURSOR
/*
    Newsletter
    Write a procedure using cursors that for active clients from the Buenos Aires area returns the email to send the newsletter to.

    Separate elements with ;.

    Hint: Data needed to do it are in the customer and address tables.
*/

