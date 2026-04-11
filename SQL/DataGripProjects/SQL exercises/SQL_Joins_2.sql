# DAY 2 SQL BASICS

#JOINS

/*
    Exercise 1 - Payments and rentals & Rentals and stocks & Film rentals
    Write a join for rental and payment tables. Display only the following columns:

payment_id,
rental_id,
amount,
rental_date,
payment_date.
Use INNER JOIN in this exercise.

Write a query that joins the rental and inventory tables and displays the following columns:

inventory_id,
rental_id,
film_id.

Write a query that joins the film and inventory tables and displays the following columns:

inventory_id,
film_id,
title,
description,
release_year.
 */

SELECT
    p.payment_id,
    r.rental_id,
    p.amount,
    r.rental_date,
    p.payment_date
FROM sakila4_169.rental AS r
INNER JOIN sakila4_169.payment AS p
ON r.rental_id = p.rental_id;

SELECT
    i.inventory_id,
    r.rental_id,
    i.film_id
FROM sakila4_169.rental AS r
INNER JOIN sakila4_169.inventory AS i
ON r.inventory_id = i.inventory_id;

SELECT
    i.inventory_id,
    f.film_id,
    f.title,
    f.description,
    f.release_year
FROM sakila4_169.film AS f
INNER JOIN sakila4_169.inventory AS i
ON f.film_id = i.film_id;

/*
    Exercise 2 - Rental report
    Using the queries and the joining method from the previous tasks,
    write a query that returns the following information about the rental:

rental id,
film id,
film title,
film description,
film rating,
rental rating,
rental date,
payment date,
payment amount.
 */

SELECT
    r.rental_id,
    f.film_id,
    f.title,
    f.description,
    f.rating,
    f.rental_rate,
    r.rental_date,
    p.payment_date,
    p.amount
FROM sakila4_169.rental AS r
INNER JOIN sakila4_169.payment AS p
ON r.rental_id = p.rental_id
INNER JOIN sakila4_169.inventory AS i
ON r.inventory_id = i.inventory_id
INNER JOIN sakila4_169.film AS f
ON i.film_id = f.film_id;

/*
    Exercise 3 - Unpaid rentals
    Using tasks.payment and sakila.rental tables find unpaid rentals (those with no payment).
 Can you find more than one solution of this exercise?
 */

SELECT
    *
FROM tasks4_169.payment AS p;

SELECT
    p.payment_id,
    r.*
FROM sakila4_169.rental AS r
LEFT JOIN tasks4_169.payment AS p
ON r.rental_id = p.rental_id
WHERE p.payment_id IS NULL;

# JOIN IN DATA MODIFICATION

/*
    Exercise 1 - Update
There are three columns in the tasks.city_country table:

city,
country_id,
country.
At this point, the country column is empty; write the appropriate query and populate it using UPDATE.

In addition, after executing your query, write another query
that will check that this column has definitely been filled.
 */

UPDATE tasks4_169.city_country AS cc
INNER JOIN sakila4_169.country AS c
ON c.country_id = cc.country_id
SET cc.country = c.country
WHERE c.country_id = cc.country_id;

SELECT
    *
FROM tasks4_169.city_country;

/*
    Exercise 2 - Delete

The table tasks.films_to_be_cleaned is a copy of the film table.
We want to remove the movies that meet the following criteria:

category_id in (1, 5, 7, 9),
length is more than 1 hour,
rating is not NC-17 or PG.
 */

SELECT
     *
FROM tasks4_169.films_to_be_cleaned;

DELETE
    f_cleaned
FROM tasks4_169.films_to_be_cleaned AS f_cleaned
INNER JOIN sakila4_169.film_category AS f_cat
ON f_cat.film_id = f_cleaned.film_id
WHERE
    (f_cat.category_id IN (1, 5, 7, 9))
OR
    (f_cleaned.length > 60)
OR
    f_cleaned.rating NOT IN ('NC-17', 'PG');

/*
    Exercise 3 - Insert

tasks.california_payments table is an empty copy of the
sakila.payments table. Write a query that adds only the payments from the customers with addresses from California.

Additionally, write a query that checks that customers available
in the tasks.california_payments table, come only from this area.
 */

INSERT INTO
    tasks4_169.california_payments(
                                   payment_id,
                                   customer_id,
                                   staff_id,
                                   rental_id,
                                   amount,
                                   payment_date
)

SELECT
    s_pay.payment_id,
    s_pay.customer_id,
    s_pay.staff_id,
    s_pay.rental_id,
    s_pay.amount,
    s_pay.payment_date
FROM sakila4_169.payment AS s_pay
INNER JOIN sakila4_169.customer AS s_cust
ON s_pay.customer_id = s_cust.customer_id
INNER JOIN sakila4_169.address AS s_addr
JOIN sakila4_169.address a
ON a.address_id = s_cust.address_id
WHERE s_addr.district = 'California';

SELECT
    *
FROM tasks4_169.california_payments;

# DELETE CASCADE

/*
    Exercise 1 - Only presentation
 */

# SELF JOIN

CREATE TABLE employees (
    id INT auto_increment primary key,
    name VARCHAR(255),
    report_to INT, -- by default nullable (can be NULL)
    FOREIGN KEY (report_to) REFERENCES employees (id)
);

INSERT INTO employees (id, name, report_to) VALUES
    (1, 'Liz', NULL), (2, 'Bart', 1), (3, 'Monica', 1), (4, 'Tom', 3);

SELECT
    e1.name AS superior,
    e2.name AS subordinate -- list of all relations
FROM
        employees AS e1 -- table employees on the left
    JOIN
        employees AS e2 -- and right side of JOIN means SELF JOIN
            ON e2.report_to = e1.id;


