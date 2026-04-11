# DAY 3 SQL BASICS

#GROUPING

/*
    Aggregate thepayment table according to the following rules:

    determine the total amount of rental shop's income,
    determine the total amount of rental shop's income divided by customers (for now don't use JOIN, only customer_id),
    determine the total amount of rented films per employee,
    using date_format function, do subpoints 2 and 3. split by months and sort the results by the keys: client_id/staff_id ascending, amount - descending.
 */

SELECT
    SUM(amount)
FROM sakila4_169.payment AS p;
--
SELECT
    p.customer_id,
    SUM(p.amount) AS total_amount_per_customer
FROM sakila4_169.payment AS p
GROUP BY p.customer_id;
--
SELECT
    p.staff_id,
    SUM(p.amount) AS total_amount_per_employee
FROM sakila4_169.payment AS p
GROUP BY p.staff_id;
--
SELECT
    p.staff_id,
    COUNT(p.rental_id) AS total_rentals_per_employee
FROM sakila4_169.payment AS p
GROUP BY p.staff_id;
--
SELECT
    p.customer_id,
    SUM(p.amount) AS total_amount_per_customer
FROM sakila4_169.payment AS p
GROUP BY p.customer_id;
--
SELECT
    p.customer_id,
    DATE_FORMAT(p.payment_date, '%M') AS rent_month,
    SUM(p.amount) AS total_amount_per_customer
FROM sakila4_169.payment AS p
GROUP BY p.customer_id,
        DATE_FORMAT(p.payment_date, '%M')
ORDER BY p.customer_id,
         SUM(p.amount) DESC;
--
SELECT
    p.staff_id,
    DATE_FORMAT(p.payment_date, '%M') AS rent_month,
    SUM(p.amount) AS total_amount_per_employee
FROM sakila4_169.payment AS p
GROUP BY
    p.staff_id,
    DATE_FORMAT(p.payment_date, '%M')
ORDER BY p.staff_id,
         SUM(p.amount) DESC;

/*
    Payment report
    Using the appropriate tables from the sakila database, prepare a payment report showing the following information:

    client's name,
    client's surname,
    client's email,
    amount of payments,
    number of payments,
    average payment amount,
    date of last payment.
    Save the query result to a database; use a view.

    How do you check if your query is correct? Write appropriate query/queries.
*/
CREATE VIEW Payment_Report_Class AS
SELECT
    c.first_name,
    c.last_name,
    c.email,
    SUM(p.amount) AS total_amount,
    COUNT(p.payment_id) AS number_of_payments,
    AVG(p.amount) AS avg_payment,
    MAX(p.payment_date) AS last_payment_date
FROM sakila4_169.customer AS c
JOIN sakila4_169.payment p on c.customer_id = p.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email;

/*
    Most profitable film (part 1) - Number of actors in a film
    Write a query that returns the following information:

    film id,
    film title,
    number of actors playing in the film.
    Save the results to a temporary table, e.g. tmp_film_actors.
*/

CREATE TEMPORARY TABLE tmp_number_of_actors2 AS
SELECT
    f.film_id,
    f.title,
    COUNT(fa.actor_id) AS number_of_actors
FROM sakila4_169.film AS f
INNER JOIN sakila4_169.film_actor fa on f.film_id = fa.film_id
GROUP BY f.film_id, f.title;

/*
    Most profitable film (part 2) - Number of film rentals
    Write a query that returns:

    film id,
    film title,
    number of film rentals.
    Save the results to a temporary table, e.g. tmp_film_rentals.

    Additionally, write a query that you can use to verify your solution.
*/
CREATE TEMPORARY TABLE tmp_number_of_rentals2 AS
SELECT
    f.film_id,
    f.title,
    COUNT(rental_id) AS number_of_rentals
FROM sakila4_169.film f
INNER JOIN sakila4_169.rental
INNER JOIN sakila4_169.inventory i on f.film_id = i.film_id
GROUP BY f.film_id, f.title;

/*
    Most profitable film (part 2) - Number of film rentals
    Write a query that returns:

    film id,
    film title,
    number of film rentals.
    Save the results to a temporary table, e.g. tmp_film_rentals.

    Additionally, write a query that you can use to verify your solution.
*/

SELECT
    f.film_id,
    SUM(p.amount) AS total_per_film
FROM sakila4_169.film AS f
INNER JOIN sakila4_169.rental AS r
INNER JOIN sakila4_169.inventory i on f.film_id = i.film_id
INNER JOIN sakila4_169.payment p ON r.rental_id = p.rental_id
GROUP BY
    f.film_id;


/*
    Most profitable film (summary)
    Prepare a report that displays the top 10 most rented films. Make the following business assumptions to prepare the report:

    film title,
    number of actors who played in it,
    the amount of revenue of the film,
    number of film rentals.
    Additionally, make sure that the amount you get for all films is correct (before you limit the results).

    Hint: This task is quite complex and requires several joins. You can make your work easier by using queries from previous tasks.
*/

SELECT
    tmp_actors.title,
    tmp_actors.number_of_actors,
    tmp_rentals.number_of_rentals,
    SUM(p.amount) AS total_amount
FROM tmp_number_of_actors2 AS tmp_actors
JOIN tmp_number_of_rentals2 AS tmp_rentals on tmp_actors.film_id = tmp_rentals.film_id
JOIN sakila4_169.film AS f on f.film_id = tmp_actors.film_id
JOIN sakila4_169.inventory AS i on i.film_id = f.film_id
JOIN sakila4_169.rental AS r on r.inventory_id = i.inventory_id
JOIN sakila4_169.payment AS p on p.rental_id= r.rental_id
GROUP BY tmp_actors.title,
         tmp_actors.number_of_actors,
         tmp_rentals.number_of_rentals
ORDER BY total_amount DESC
LIMIT 10;

#ROLLUP

/*
    ROLLUP
    Write a query that generates a report on:

    the store's total sales and its employees,
    the store's total sales (no division by employee),
    total sales.
    Additionally – choose your own way to sort rows.

    Hint:
    You can check your query using sales_by_store, where a fragment of the expected result is.
*/

SELECT
     CONCAT(city, ', ', country) AS city_country,
     p.staff_id,
     SUM(p.amount) AS total_payment
FROM sakila4_169.payment AS p JOIN sakila4_169.staff s on p.staff_id = s.staff_id
JOIN sakila4_169.store s2 on s2.store_id = s.store_id
JOIN sakila4_169.address a on a.address_id = s.address_id
JOIN sakila4_169.city c on c.city_id = a.city_id
JOIN sakila4_169.country c2 on c2.country_id = c.country_id
GROUP BY
    city_country, p.staff_id WITH ROLLUP;

/*
    ROLLUP and HAVING
    Based on the payment table write a query that:

    determines the sum of payments divided by client and by employee,
    determines the sum of payments per client,
    determines the sum of payments.
    Do two versions of the exercise:

    Using only ROLLUP,
    Adding the HAVING clause to the GROUP BY for payments above 70.
    How are the results of the queries different? To make it easier to notice the difference, do the exercise only for the first 3 customers (customer_id < 4).
*/

SELECT
    customer_id,
    staff_id,
    SUM(amount) AS total_amount
FROM payment
WHERE customer_id < 4
GROUP BY customer_id, staff_id WITH ROLLUP;
#HAVING SUM(amount) > 70;

#WINDOW FUNCTIONS

/*
    Actors ranking
    Write a query that will create a ranking of actors based on the average rating from the movies they played in. To do the exercise assume the following:

    use the actor_analytics view,
    use the ROW_NUMBER() function to create the ranking.
    Sort the actors from the best to the worst, e.g.: 1 - highest rating.

    Additionally, review the table and see how rows that have the same values are treated.
*/

SELECT
    aa.actor_id,
    aa.first_name,
    aa.last_name,
    aa.avg_film_rate,
    ROW_NUMBER() over (ORDER BY aa.avg_film_rate DESC) AS rn
FROM sakila4_169.actor_analytics AS aa;

/*
    Cumulative sum
    (often shortened to cumsum), as the name suggests, refers to the cumulative amount; window functions let us count according to a specified order: this is done using the ORDER BY clause.

    In a sense ROW_NUMBER() was already an example of a cumsum regarding the count of elements in a partition. In statistics this approach can be used to determine e.g. a cumulative distribution function

    Our task is going to be to write a clause that determines the following accumulating values.

    MIN for avg_film_rate,
    SUM for actor_payload,
    MAX for longest_movie_duration.
    Use actor_id as a sorting key - ascending.
*/

SELECT
    aa.actor_id,
    aa.films_amount,
    aa.actor_payload,
    ROW_NUMBER() over () AS rn,
    MIN(aa.avg_film_rate) OVER() AS min,
    SUM(aa.actor_payload) OVER(ORDER BY aa.actor_id) AS sum,
    MAX(aa.longest_movie_duration) OVER() AS max
FROM sakila4_169.actor_analytics AS aa
ORDER BY aa.actor_id;

/*
    Pareto principle
    In short it states that 20% of the society holds 80% of wealth.

    In the context of a video rental company, we want to perform a similar analysis -
    to do this we will use window functions. Let's once again use the actor data from
    the actor_analytics view and check what % of actors is responsible for what % of income of the rental shop.
*/

SELECT
    aa.actor_id,
    aa.first_name,
    aa.last_name,
    aa.actor_payload,
    ROW_NUMBER() OVER (ORDER BY aa.actor_payload DESC) AS actor_rank,
    ROUND(CUME_DIST() OVER (ORDER BY aa.actor_payload DESC) * 100, 2) AS actor_percentage,
    SUM(aa.actor_payload) OVER (ORDER BY aa.actor_payload DESC) AS running_payload,
    SUM(aa.actor_payload) OVER () AS total_sum,
    ROUND(
        (
            SUM(aa.actor_payload) OVER (ORDER BY aa.actor_payload DESC)
            / SUM(aa.actor_payload) OVER ()
        ) * 100, 2) AS running_total_pct
FROM sakila4_169.actor_analytics AS aa;

# 1 SOLUTION CLASS

SELECT
    actor_id,
    first_name,
    last_name,
    actor_payload,
    ROW_NUMBER() OVER (ORDER BY actor_payload DESC) AS redni_broj,
    100 * ROW_NUMBER() OVER (ORDER BY actor_payload DESC) / COUNT(*) OVER () AS running_pct,
    SUM(actor_payload) OVER (ORDER BY actor_payload DESC) AS running_payload,
    SUM(actor_payload) OVER (ORDER BY actor_payload DESC) / SUM(actor_payload) OVER () * 100 AS running_payload_PCT
FROM sakila4_169.actor_analytics
ORDER BY actor_payload DESC;

# 2 SOLUTION - GPT

WITH actor_pareto AS (
    SELECT
        actor_id,
        actor_payload,
        ROW_NUMBER() OVER (ORDER BY actor_payload DESC) AS actor_rank,
        COUNT(*) OVER () AS total_actors,
        SUM(actor_payload) OVER (
            ORDER BY actor_payload DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_payload,
        SUM(actor_payload) OVER () AS total_payload
    FROM actor_analytics
)
SELECT
    actor_id,
    actor_payload,
    actor_rank,
    ROUND(actor_rank * 100.0 / total_actors, 2) AS actor_percent,
    ROUND(cumulative_payload * 100.0 / total_payload, 2) AS payload_percent
FROM actor_pareto
ORDER BY actor_payload DESC;

/*
    Ranking
    Using RANK, DENSE_RANK and ROW_NUMBER, create a ranking of the movies by number of rentals.

    Notice the results of each function.

    When you do this exercise, add a partition according to rating.

    In this exercise you can use the sakila.film_analytics table.
*/

SELECT
    fa.title,
    fa.rating,
    fa.rentals,
    RANK() OVER(PARTITION BY fa.rating ORDER BY fa.rentals DESC) AS film_rank,
    DENSE_RANK() OVER(PARTITION BY fa.rating ORDER BY fa.rentals DESC) AS film_dense_rank,
    ROW_NUMBER() OVER(PARTITION BY fa.rating ORDER BY fa.rentals DESC) AS film_row_number
FROM sakila4_169.film_analytics AS fa;

#DATETIME

/*
    Calendar
    Using ROW_NUMBER and appropriate date values create a calendar table in the database, that:

    will start from '2000-01-01',
    will end on '2030-12-31'.
    The calendar table should have the following columns:

    date (date),
    year (date_year),
    month (date_month),
    day (date_day),
    number of day of week (day_of_week),
    number  of week in the year (week_of_year),
    date of generating the calendar (last_update).
*/

WITH cte_numbers AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY p.payment_id) - 1 AS rn
    FROM sakila4_169.payment AS p
    LIMIT 11323
)
SELECT
    DATE_ADD('2000-01-01', INTERVAL rn DAY) AS `date`,
    YEAR(DATE_ADD('2000-01-01', INTERVAL rn DAY)) AS date_year,
    MONTH(DATE_ADD('2000-01-01', INTERVAL rn DAY)) AS date_month,
    DAY(DATE_ADD('2000-01-01', INTERVAL rn DAY)) AS date_day,
    DAYOFWEEK(DATE_ADD('2000-01-01', INTERVAL rn DAY)) AS day_of_week,
    WEEK(DATE_ADD('2000-01-01', INTERVAL rn DAY), 1) AS week_of_year,
    CURRENT_DATE() AS last_update
FROM cte_numbers
WHERE DATE_ADD('2000-01-01', INTERVAL rn DAY) <= '2030-12-31';