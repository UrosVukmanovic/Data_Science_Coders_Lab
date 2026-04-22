# Zadaci

/*

1 napisati upite za sledeće zahteve:
• Lista svih filmova
• Lista svih glumaca koji se zovu "Julia"
• Broj filmova po jeziku
 */

SELECT
    f.title
FROM sakila4_169.film AS f;
--
SELECT
    a.first_name,
    a.last_name
FROM sakila4_169.actor AS a
WHERE a.first_name = 'Julia';
--
SELECT
    l.name,
    f.language_id,
    COUNT(film_id) AS number_of_films
FROM sakila4_169.film AS f
LEFT JOIN sakila4_169.language AS l
ON f.language_id = l.language_id
GROUP BY
    f.language_id,
    l.name;

SELECT
    *
FROM sakila4_169.film;

# U mojoj tabeli film jedini language_id je 1 a original_language_id su null vrednosti,

/*
    2. napisati upite za sledeće zahteve:
• Svi filmovi sa glumcem "JOHNNY LOLLOBRIGIDA"
• Broj iznajmljivanja po korisniku
• Top 5 najdužih filmova
 */

SELECT
    a.first_name,
    a.last_name,
    f.title
FROM sakila4_169.film AS f
INNER JOIN sakila4_169.film_actor as fa
ON f.film_id = fa.film_id
INNER JOIN sakila4_169.actor AS a
ON fa.actor_id = a.actor_id
WHERE
    a.first_name = 'JOHNNY' AND
    a.last_name = 'LOLLOBRIGIDA';
--

SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    COUNT(r.rental_id)  AS number_of_rentals
FROM sakila4_169.rental AS r
INNER JOIN sakila4_169.customer AS c
ON r.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    full_name
ORDER BY number_of_rentals DESC;

--

SELECT
    f.title AS movie_title,
    f.length AS movie_duration
FROM sakila4_169.film AS f
ORDER BY movie_duration DESC
LIMIT 5;

/*
    3.  napisati upite za sledeće zahteve:
• Korisnici koji su iznajmili više od 30 filmova
• Najčešće iznajmljivani film
• Prihodi po gradu
• Filmovi koji nisu nikada iznajmljeni
 */

 SELECT
     c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    COUNT(r.rental_id)  AS number_of_rentals
FROM sakila4_169.rental AS r
INNER JOIN sakila4_169.customer AS c
ON r.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    full_name
HAVING number_of_rentals > 30
ORDER BY number_of_rentals DESC;

--

SELECT
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS number_of_rental
FROM sakila4_169.film AS f
INNER JOIN sakila4_169.inventory AS i
ON f.film_id = i.film_id
INNER JOIN sakila4_169.rental AS r
ON i.inventory_id = r.inventory_id
GROUP by f.title, f.film_id
ORDER BY number_of_rental DESC
LIMIT 1;

--

SELECT
    f.film_id,
    f.title
FROM sakila4_169.film AS f
LEFT JOIN sakila4_169.inventory AS i
ON f.film_id = i.film_id
LEFT JOIN sakila4_169.rental AS r
ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

--

SELECT
    f.film_id,
    f.title
FROM sakila4_169.film f
WHERE NOT EXISTS (
                    SELECT 1
                    FROM sakila4_169.inventory AS i
                    JOIN sakila4_169.rental AS r
                    ON i.inventory_id = r.inventory_id
                     WHERE i.film_id = f.film_id
                    );

/*
    Bonus zadatak
U vežbi Day1- SQL basics/Filtering/Actors stoji za zadatak:
Get familiar with the structure of sakila.actor_analytics and write queries that:
• display actors who played in more than 25 films
• display actors who played in more than 20 films and whose average rating is above 3.3.
• display actors who played in more than 20 films and whose average rating is above 3.3 or the income
from rentals (actor_payload) is above 2000.
Da li biste isto mogli da uradite bez korišćenja tabele sakila.actor_analytics? Ovo podrazumeva da se
više tabela mora međusobno povezati(join). Rezultate uporediti sa izlazom upita kada se koristi tabela
sakila.actor_analytics.
 */


/*
    BONUS TASK

    Napomena 1:
    U trećem zadatku uslov je potencijalno dvosmislen:
        more than 20 films and rating > 3.3 or payload > 2000

    To se može tumačiti na dva načina:
        1) (num_of_movies > 20) AND ((avg_rating > 3.3) OR (actor_payload > 2000))
        2) (num_of_movies > 20) OR ((avg_rating > 3.3) AND (actor_payload > 2000))

    U ovom rešenju korišćena je druga interpretacija, u skladu sa napisanim WHERE uslovom.
    Ovo je važno naglasiti jer formulacija zadatka nije potpuno jednoznačna.

    Napomena 2:
    U cte_actor_payload svaki payment se pridružuje svakom glumcu koji igra u filmu.
    To znači da ako film ima više glumaca, isti payment ulazi u zbir svakog od njih.
    Zbog toga zbir actor_payload kroz sve glumce nije jednak ukupnom realnom prihodu baze.
    Ovakav pristup je ipak validan ako actor_payload tumačimo kao prihod filma pripisan svakom glumcu koji u njemu učestvuje.

    Napomena 3:
    U trećem zadatku koristi se LEFT JOIN prema cte_actor_payload kako glumci bez ikakvih payment zapisa
    ne bi bili izbačeni iz rezultata. U tom slučaju COALESCE postavlja actor_payload na 0.
*/


/* 1. Actors in more than 25 films */
SELECT
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(f.film_id) AS num_of_movies
FROM sakila4_169.film AS f
INNER JOIN sakila4_169.film_actor AS fa
ON f.film_id = fa.film_id
INNER JOIN sakila4_169.actor AS a
ON fa.actor_id = a.actor_id
GROUP BY
    a.actor_id,
    a.first_name,
    a.last_name
HAVING
    num_of_movies > 25
ORDER BY
    num_of_movies DESC;

-- --------------------------------------------------------------------------

/* 2. Actors in more than 20 films with rating > 3.3 */
WITH cte_actor_rating AS (
        SELECT
            a.actor_id,
            a.first_name,
            a.last_name,
            ROUND(AVG(rental_rate),2) AS avg_rating
        FROM sakila4_169.film AS f
        INNER JOIN sakila4_169.film_actor AS fa
        ON f.film_id = fa.film_id
        INNER JOIN sakila4_169.actor AS a
        ON fa.actor_id = a.actor_id
        GROUP BY
            a.actor_id,
            a.first_name,
            a.last_name
),
cte_number_of_movies AS(
        SELECT
            a.actor_id,
            COUNT(f.film_id) AS num_of_movies
        FROM sakila4_169.film AS f
        INNER JOIN sakila4_169.film_actor AS fa
        ON f.film_id = fa.film_id
        INNER JOIN sakila4_169.actor AS a
        ON fa.actor_id = a.actor_id
        GROUP BY
            a.actor_id
)
SELECT
    cte_actor_rating.actor_id,
    cte_actor_rating.first_name,
    cte_actor_rating.last_name,
    cte_number_of_movies.num_of_movies,
    cte_actor_rating.avg_rating
FROM cte_actor_rating
INNER JOIN cte_number_of_movies
ON cte_actor_rating.actor_id = cte_number_of_movies.actor_id
WHERE
    cte_number_of_movies.num_of_movies > 20 AND
    cte_actor_rating.avg_rating > 3.3
ORDER BY
    cte_number_of_movies.num_of_movies  DESC,
    cte_actor_rating.avg_rating         DESC;

-- --------------------------------------------------------------------------

/* 3. Actors in more than 20 films or actors with rating > 3.3 and payload > 2000 */
WITH cte_actor_rating AS (
        SELECT
            a.actor_id,
            a.first_name,
            a.last_name,
            ROUND(AVG(rental_rate),2) AS avg_rating
        FROM sakila4_169.film AS f
        INNER JOIN sakila4_169.film_actor AS fa
        ON f.film_id = fa.film_id
        INNER JOIN sakila4_169.actor AS a
        ON fa.actor_id = a.actor_id
        GROUP BY
            a.actor_id,
            a.first_name,
            a.last_name
),
cte_actor_payload AS (
        SELECT
            a.actor_id,
            a.first_name,
            a.last_name,
            SUM(p.amount) AS actor_payload
        FROM sakila4_169.payment AS p
        INNER JOIN sakila4_169.rental AS r
        ON p.rental_id = r.rental_id
        INNER JOIN sakila4_169.inventory AS i
        ON r.inventory_id = i.inventory_id
        INNER JOIN sakila4_169.film AS f
        ON i.film_id = f.film_id
        INNER JOIN sakila4_169.film_actor AS fa
        ON f.film_id = fa.film_id
        INNER JOIN sakila4_169.actor AS a
        ON fa.actor_id = a.actor_id
        GROUP BY a.actor_id, a.first_name, a.last_name
),
cte_number_of_movies AS(
        SELECT
            a.actor_id,
            COUNT(f.film_id) AS num_of_movies
        FROM sakila4_169.film AS f
        INNER JOIN sakila4_169.film_actor AS fa
        ON f.film_id = fa.film_id
        INNER JOIN sakila4_169.actor AS a
        ON fa.actor_id = a.actor_id
        GROUP BY
            a.actor_id
)
SELECT
    cte_number_of_movies.actor_id,
    cte_actor_rating.first_name,
    cte_actor_rating.last_name,
    cte_number_of_movies.num_of_movies,
    COALESCE(cte_actor_payload.actor_payload, 0) AS actor_payload,
    cte_actor_rating.avg_rating
FROM cte_number_of_movies
INNER JOIN cte_actor_rating
ON cte_number_of_movies.actor_id = cte_actor_rating.actor_id
LEFT JOIN cte_actor_payload
ON cte_actor_rating.actor_id = cte_actor_payload.actor_id
WHERE
    (cte_number_of_movies.num_of_movies > 20 ) OR
    (cte_actor_rating.avg_rating > 3.3 AND COALESCE(cte_actor_payload.actor_payload, 0) > 2000)
ORDER BY
    cte_number_of_movies.num_of_movies  DESC,
    COALESCE(cte_actor_payload.actor_payload, 0) DESC,
    cte_actor_rating.avg_rating         DESC;



