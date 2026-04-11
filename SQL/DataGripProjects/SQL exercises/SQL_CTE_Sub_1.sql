# DAY 1 SQL BASICS

#FILTERING

/*
    Exercise 1 - Rentals
    Write queries that display information (sakila.rental) based on the following criteria:
    about rentals from 2005,
    about rentals from 2005-05-24
 */

SELECT
    *
FROM
    (
        SELECT
            sa.staff_id,
            sa.rental_id,
            sa.customer_id,
            CAST(rental_date AS YEAR ) AS rental_year
        FROM sakila4_169.rental AS sa
    ) AS t
WHERE t.rental_year = 2005;

SELECT
    *
FROM sakila4_169.rental sa
WHERE
  sa.rental_date BETWEEN '2005-01-01' AND '2005-12-31';

/*
    Exercise 2 - Rental customers
    all active customers,
    all active customers or those starting from ` ANDRE'.
    all inactive customers with store_id = 1,
    customers whose email address is in a domain different from sakilacustomer.org. Are there any?
    customers with unique values in the create_date column.
 */

SELECT
    *
FROM sakila4_169.customer c
WHERE c.active = 1;

SELECT
    *
FROM sakila4_169.customer c
WHERE c.active = 1 OR c.first_name LIKE 'ANDRE%';

SELECT
    *
FROM sakila4_169.customer c
WHERE c.active = 0 AND c.store_id = 1;

SELECT
    *
FROM sakila4_169.customer c
WHERE c.email NOT LIKE '%sakilacustomer.org'; # NO CUSTOMERS WITH DIFFERENT EMAIL DOMAIN

SELECT DISTINCT
        c.create_date
FROM sakila4_169.customer c;

/*
    Exercise 3 - Actors
    Get familiar with the structure of sakila.actor_analytics and write queries that:
    display actors who played in more than 25 films,
    display actors who played in more than 20 films and whose average rating is above 3.3,
    display actors who played in more than 20 films and whose average rating is above 3.3 or the income from rentals (actor_payload) is above 2000.
 */

 SELECT
     *
 FROM sakila4_169.actor_analytics aa
 WHERE aa.films_amount > 25;

SELECT
    *
FROM sakila4_169.actor_analytics aa
WHERE aa.films_amount > 20 AND aa.avg_film_rate > 3.3;

SELECT
    *
FROM sakila4_169.actor_analytics aa
WHERE
    (aa.films_amount > 20 AND aa.avg_film_rate > 3.3) OR
    aa.actor_payload > 2000;

#FORMATTING OUTPUT DATA

/*
    Exercise 1 - Aliasing
    Get familiar with the structure of sakila.actor_analytics and write queries that:
    display actors who played in more than 25 films,
    display actors who played in more than 20 films and whose average rating is above 3.3,
    display actors who played in more than 20 films and whose average rating is above 3.3 or the income from rentals (actor_payload) is above 2000.
    PASS
*/

/*
    Exercise 2 - Formatting dates
    In the sakila.payment table there is information about payments made by the clients of the DVD rental store. Write a query to display the payment_date column in the following formats:
    'year/month/day',
    'year-name_of_month-day_of_week',
    'year-number_of_week',
    'year/month/day@day_of week_name',
'year/month/day@day_of_week_number'.
*/

SELECT
    p.payment_id,
    DATE_FORMAT(p.payment_date, '%Y-%m-%d')
FROM sakila4_169.payment AS p;

SELECT
    p.payment_id,
    DATE_FORMAT(p.payment_date, '%Y-%u')
FROM sakila4_169.payment AS p;

/*
    Exercise 3 - Formatting Dates
    In the sakila.payment table there is information about payments made by the clients of the DVD rental store. Write a query to display the payment_date column in the following formats:
    'year/month/day',
    'year-name_of_month-day_of_week',
    'year-number_of_week',
    'year/month/day@day_of week_name',
'year/month/day@day_of_week_number'.
*/

SELECT
    DATE_FORMAT(p.payment_date, '%Y-%m-%d'),
    DATE_FORMAT(p.payment_date, '%y-%m-%d'),
    DATE_FORMAT(p.payment_date, '%Y-%M-%D')
FROM sakila4_169.payment AS p;

/*
    Exercise 4 - Predefined format of dates
    Get familiar with the GET_FORMAT() method: documentation link, which has predefined formats of selected date display standards. Format the payment_date column from the sakila.payment table according to the US standard.

    Call the created column: payment_date_usa_formatted.

    Hint:
    Use the method like this - GET_FORMAT(DATE, FORMAT_NAME).
*/

SELECT
    DATE_FORMAT(p.payment_date, GET_FORMAT(DATETIME, 'USA'))
FROM sakila4_169.payment AS p;

/*
    Exercise 5 - LEAST
    Using sakila.film_list, write and perform a query that:

    returns the lowest value in the columns: price, length,
    returns the lowest value in the columns: price, length, rating.
    What is the difference between the results from subpoints 1 and 2? Where does it come from?

Hint: To better illustrate which of the values is going to be considered it is best to list the column data using a SELECT command.
*/

SELECT
    fl.price,
    fl.length,
    fl.rating,
    LEAST(fl.price, fl.length, fl.rating) AS min_price_length_rating,
    CAST(rating AS SIGNED),
    ASCII(SUBSTRING(rating, 1, 1))
FROM sakila4_169.film_list AS fl;

/*
    Exercise 6 - GREATEST
    Similar to the exercise on LEAST, based on sakila.film_list, write and perform a query that:

    returns the highest value in the columns: price, length,
    returns the highest value in the columns: price, length, rating.
    Additionally, apart from the GREATEST call, also display the component columns,
    e.g. price, length and rating in the results.

    Consider why the function returned such a result and not something else.

    Note: Comparing a time unit and an amount may not be the
    greatest idea but in this case we want to present how the function behaves.
*/

SELECT
    fl.price,
    fl.length,
    fl.rating,
    GREATEST(fl.price, fl.length, fl.rating) AS MAX_price_length_rating,
    CAST(rating AS SIGNED),
    ASCII(SUBSTRING(rating, 1, 1))
FROM sakila4_169.film_list AS fl;

# UNION

/*
    Exercise 1 - NAMES
    Names in SakilaDB
    Using tables:

    sakila.customer,
    sakila.actor,
    sakila.staff,
    display everybody's first name without repetitions.
*/

SELECT
    c.first_name, 'customer' AS category
FROM sakila4_169.customer AS c
UNION
SELECT
    a.first_name, 'actor' AS category
FROM sakila4_169.actor AS a
UNION
SELECT
    s.first_name, 'staff' AS category
FROM sakila4_169.staff AS s;

/*
    Exercise 2 - FILM CATEGORIES
    Using the UNION property of returning a set by default,
    modify the query below to return the categories of films (category)
    without repetitions (do not use the DISTINCT clause here):

    SELECT * FROM sakila.nicer_but_slower_film_list
*/

SELECT
    category
FROM sakila4_169.nicer_but_slower_film_list
UNION
SELECT category
FROM sakila4_169.nicer_but_slower_film_list;

# SUBQUERIES

/*
    Exercise 1 - Store sales
    Using data from sakila.sales_by_store and sakila.sales_total
    find stores where total sales is higher than the half of total sales of the rental store.
*/

SELECT
    sbs.store
FROM sakila4_169.sales_by_store AS sbs
WHERE sbs.total_sales >(
        SELECT
            st.total_sales/2
        FROM sakila4_169.sales_total AS st
        );

/*
    Exercise 2 - FILM RATINGS STATISTICS
    Get familiar with the structure of sakila.rating_analytics, which has aggregated information regarding particular ratings for all films. Then do the following:

    Analyzing only the data structure, consider which row can determine statistics for all ratings (without rating division),
    Find the ratings which are higher than the average for all movies, without rating division,
    Find the ratings where the renting time is shorter than the global average,
    Use a subquery to display the statistics for id_rating = 3,
    Use a subquery to display the statistics for id_rating = 3, 2, 5,
    Additionally, as an exercise:

    Write a query that shows which rating is the most popular one,
    Write a query that reveals which rating has, on average, the shortest movies.
*/

SELECT
    *
FROM sakila4_169.rating_analytics AS ra
WHERE ra.avg_rental_duration >
      (
          SELECT
              sakila4_169.rating_analytics.avg_rental_duration
          FROM sakila4_169.rating_analytics
          WHERE rating_analytics.rating IS NULL
          );
--
SELECT
    *
FROM sakila4_169.rating_analytics AS ra
WHERE ra.avg_rental_duration <
      (
          SELECT
              sakila4_169.rating_analytics.avg_rental_duration
          FROM sakila4_169.rating_analytics
          WHERE rating_analytics.rating IS NULL
          );
--
SELECT
    *
FROM sakila4_169.rating_analytics AS ra
WHERE ra.rating = (
    SELECT
        r.rating
    FROM sakila4_169.rating AS r
    WHERE r.id_rating = 3
    );
--
# 1 Solution
SELECT
    ra.*
FROM sakila4_169.rating_analytics AS ra
WHERE ra.rating = (
    SELECT
        r.rating
    FROM sakila4_169.rating AS r
    WHERE r.id_rating = 2
    )
    OR ra.rating = (
    SELECT
        r.rating
    FROM sakila4_169.rating AS r
    WHERE r.id_rating = 3
    )
    OR ra.rating = (
        SELECT
        r.rating
    FROM sakila4_169.rating AS r
    WHERE r.id_rating = 5
    );
--
# 2 Solution

SELECT
    ra.*
FROM sakila4_169.rating_analytics AS ra
WHERE ra.rating IN (
    SELECT
        r.rating
    FROM sakila4_169.rating AS r
    WHERE r.id_rating IN (2,3,5) # When there is more than 1 condition for filtering use IN clause
    );
--
SELECT
    *
FROM sakila4_169.rating_analytics AS ra
WHERE ra.rentals = (
    SELECT
        r_ana.rentals
    FROM sakila4_169.rating_analytics AS r_ana
    WHERE r_ana.rating IS NOT NULL
    ORDER BY r_ana.rentals DESC
    LIMIT 1
    );
--

SELECT
    *
FROM sakila4_169.rating_analytics AS ra
WHERE ra.avg_film_length = (
    SELECT
        r_ana.avg_film_length
    FROM sakila4_169.rating_analytics AS r_ana
    WHERE r_ana.rating IS NOT NULL
    ORDER BY r_ana.rentals ASC
    LIMIT 1
    );



/*
    Exercise 3 - ACTORS STATISTICS
    Do the following:

    1.Find the actor/actress with the name of ZERO and the surname: CAGE, display all statistics for their id,
    2. Display actors who played in at least 30 films,
    3. Using the results from the previous point display all of their information from sakila.actor.
    Additionally:
    4. Find the actors who played in the movies with the length of (longest_movie_duration) of 184, 174, 176, 164,
    5. Using the results from the previous subpoint, find these films in sakila.film (this will require more than one subquery).

    Hint:
    In the last task you can for example divide the queries for sakila.actor_analytics and sakila.film_actor tables into modules,
    and query sakila.film at the end, joining them appropriately in WHERE.
*/
WITH cte_actors_films AS (
    SELECT
    T.*
FROM
    (
        SELECT
        aa.actor_id,
        aa.first_name,
        aa.last_name,
        aa.films_amount,
        aa.longest_movie_duration
    FROM sakila4_169.actor_analytics AS aa
    WHERE aa.first_name LIKE 'ZERO' AND aa.last_name LIKE 'CAGE'
    UNION
    SELECT
        aa2.actor_id,
        aa2.first_name,
        aa2.last_name,
        aa2.films_amount,
        aa2.longest_movie_duration
    FROM sakila4_169.actor_analytics AS aa2
    ) AS T
WHERE
    T.films_amount >= 30 AND
    T.longest_movie_duration IN (184, 176, 174, 164)
),
cte_movies AS (SELECT *
               FROM sakila4_169.film_actor AS fa
)
SELECT
    cm.actor_id,
    (SELECT first_name FROM cte_actors_films a WHERE a.actor_id = cm.actor_id) AS first_name,
    (SELECT last_name FROM cte_actors_films a WHERE a.actor_id = cm.actor_id) AS last_name,
    cm.film_id,
    (SELECT title FROM sakila4_169.film f WHERE f.film_id = cm.film_id) AS film_title
FROM cte_movies cm
WHERE cm.actor_id IN (
    SELECT actor_id
    FROM cte_actors_films
);

SELECT
    T.*
FROM
    (
        SELECT
        aa.actor_id,
        aa.first_name,
        aa.last_name,
        aa.films_amount,
        aa.longest_movie_duration
    FROM sakila4_169.actor_analytics AS aa
    WHERE aa.first_name LIKE 'ZERO' AND aa.last_name LIKE 'CAGE'
    UNION
    SELECT
        aa2.actor_id,
        aa2.first_name,
        aa2.last_name,
        aa2.films_amount,
        aa2.longest_movie_duration
    FROM sakila4_169.actor_analytics AS aa2
    ) AS T
WHERE
    T.films_amount >= 30 AND
    T.longest_movie_duration IN (184, 176, 174, 164);



/*
    Exercise 4 - FILM CATEGORIES
    Using sakila.film_list:

    Write a query to display the films with the genres: Horror, Documentary, and Family with the rating of P or NC-17,
    Using the results of the previous task and sakila.film_text, display the descriptions of these films.
    Additionally:
    3. Sort sakila.film_list by the Category key - ascending; Price - descending,
    4. Sort sakila.film_list by key Rating - ascending; Length - descending.
*/
WITH cte_film_descr AS (
    SELECT
        ft.film_id,
        ft.description
FROM sakila4_169.film_text AS ft
),
cte_f_lst AS (SELECT fs.FID,
                     fs.title,
                     fs.category,
                     fs.rating,
                     fs.price,
                     fs.length
              FROM sakila4_169.film_list AS fs
              WHERE (fs.rating LIKE 'P%' OR fs.rating = 'NC-17') AND
                    (fs.category IN ('Horror', 'Documentary', 'Family'))
              ORDER BY fs.category ASC,
                       fs.price DESC
    )
SELECT
    cte_f_lst.*,
    (
        SELECT
            cte_film_descr.description
        FROM cte_film_descr
        WHERE cte_f_lst.FID = cte_film_descr.film_id
    ) AS description
FROM cte_f_lst;

