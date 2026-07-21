/*
	Remember to put the solutions to the assignments (SQL queries) in a text file, which you will then send to your mentor.

Write the following queries:

A query finding all students,
A query finding all teachers,
A query finding only first names of students,
A query finding only surnames and emails of students,
*/

-- A query finding all students,
SELECT 
	*
FROM public.students s;

--A query finding all teachers,
SELECT 
	*
FROM public.teachers t;

--A query finding only first names of students,
SELECT 
	s."name"
FROM public.students s;

--A query finding only surnames and emails of students,
SELECT 
	s.surname,
	s.email 
FROM public.students s;

/*
 WHERE clause
Write a following query:

Finding all students whose names start with the letter A,
Finding teachers with a salary above PLN 1900,
Finding marks above 4,
Finding the teacher whose name is Bryan Cubes (note down the teacher's id on a piece of paper),
Finding marks given by Bryan (use the id from the previous point — the marks you seek will have this id in their teacher_id field).
 */

--Finding all students whose names start with the letter A,
SELECT 
    *
FROM public.students s
WHERE s."name" LIKE 'A%'; -- using LIKE clause to find all students with name that starts on "A"

--Finding teachers with a salary above PLN 1900,
SELECT 
    *
FROM public.teachers t
WHERE t.pay > 1900; -- in WHERE claues we filter our condition

--Finding marks above 4,
SELECT
    *
FROM public.marks m
WHERE m.mark > 4; -- in WHERE claues we filter our condition

--Finding the teacher whose name is Bryan Cubes (note down the teacher's id on a piece of paper),
SELECT
    *
FROM public.teachers t
WHERE t."name" = 'Bryan Cubes'; -- in WHERE claues we filter our condition

--Finding marks given by Bryan (use the id from the previous point — the marks you seek will have this id in their teacher_id field).
SELECT
    m.mark_id,
    m.student_id,
    m.teacher_id,
    m.mark
FROM public.marks m
WHERE m.teacher_id = 3; -- in WHERE claues we filter our condition

/*
 	AND and OR clauses
Write a following query:

A query finding the data of a student whose name is Damian and surname is Forrester,
A query finding Damian Forrester's marks higher than 3,
All students with names starting from D or B.
 */

--A query finding the data of a student whose name is Damian and surname is Forrester,
SELECT
    s.student_id,
    s."name",
    s.surname,
    s.email
FROM public.students s
WHERE s."name" = 'Damian'
  AND s.surname = 'Forrester'; -- using logical operator to combine filters in WHERE clause

--A query finding Damian Forrester's marks higher than 3,

SELECT
    m.mark_id,
    m.mark,
    s."name",
    s.surname
FROM public.marks m
INNER JOIN public.students s
    ON m.student_id = s.student_id  -- using relations to avoid hardcoding student_id
WHERE s."name" = 'Damian'
  AND s.surname = 'Forrester'
  AND m.mark > 3;

--All students with names starting from D or B.
SELECT
    s.student_id,
    s."name",
    s.surname
FROM public.students s
WHERE s."name" LIKE 'D%'
   OR s."name" LIKE 'B%';

/*
 	ORDER BY clause
Write a following query:

A query finding marks given by Clara Oakley, ordered from high to low,
A query finding all students ordered alphabetically by surname,
A query finding all marks of the student whose email is bertram.adams@yahoo.com from high to low.
 */

--A query finding marks given by Clara Oakley, ordered from high to low,
SELECT
    m.mark_id,
    m.mark,
    t."name"
FROM public.marks m
INNER JOIN public.teachers t
    ON m.teacher_id = t.teacher_id
WHERE t."name" = 'Clara Oakley'
ORDER BY m.mark DESC;

--A query finding all students ordered alphabetically by surname,
SELECT
    s.student_id,
    s."name",
    s.surname
FROM public.students s
ORDER BY s.surname ASC;

--A query finding all marks of the student whose email is bertram.adams@yahoo.com from high to low.
SELECT
    m.mark_id,
    m.mark,
    s.email
FROM public.marks m
INNER JOIN public.students s
    ON m.student_id = s.student_id
WHERE s.email = 'bertram.adams@yahoo.com'
ORDER BY m.mark DESC;

/*
 	Adding new teacher
Write a following query:

Try to add a new teacher to the database with the following data:
teacher_id - 2
name - John Koval
pay - 1300
Has adding the teacher worked? If not, what error the database returned?
Add the teacher from the previous point, specifying only his name and salary. Do not give the primary key (teacher_id field),
Load all teachers. What primary key has been assigned to Jan Kowalski?
Try adding a new teacher by giving all fields (together with the primary key – teacher_id field). 
But this time as the teacher_id give the value that does not yet exist in the table 
(e.g. greater by one than the last value in the filed).
 */

/*
    Adding new teacher

    Napomena:
    U tekstu zadatka prvo piše "John Koval", a kasnije "Jan Kowalski".
    Pošto je prvi konkretan unos definisan kao "John Koval",
    u ovom rešenju koristim ime "John Koval".
*/


/*
    1. Pokušaj dodavanja nastavnika sa eksplicitnim teacher_id = 2.

    Očekivanje:
    Ako teacher_id = 2 već postoji u tabeli, ovaj INSERT neće uspeti.

    Tipična greška:
    ERROR: duplicate key value violates unique constraint "teachers_pkey"

    Razlog:
    teacher_id je primary key i mora biti jedinstven.
*/

INSERT INTO public.teachers (teacher_id, "name", pay)
VALUES (2, 'John Koval', 1300);


/*
    2. Dodavanje nastavnika bez teacher_id.

    Ovde ne unosimo primary key ručno.
    Baza sama dodeljuje sledeću dostupnu vrednost preko SERIAL / auto-increment mehanizma.
*/

INSERT INTO public.teachers ("name", pay)
VALUES ('John Koval', 1300);


/*
    3. Provera koji teacher_id je dodeljen novom nastavniku.
*/

SELECT
    *
FROM public.teachers t
WHERE t."name" = 'John Koval';


/*
    4. Dodavanje nastavnika sa eksplicitnim teacher_id koji još ne postoji.

    Prvo pogledamo najveći postojeći teacher_id.
*/

SELECT
    MAX(t.teacher_id) AS current_max_teacher_id
FROM public.teachers t;


/*
    Zatim unesemo novu vrednost koja ne postoji.
    Primer: ako je najveći teacher_id 6, možemo uneti 7.

    Napomena:
    Broj ispod promeni prema rezultatu prethodnog SELECT-a.
*/

INSERT INTO public.teachers (teacher_id, "name", pay)
VALUES (7, 'John Koval', 1300);


/*
    Finalna provera svih nastavnika.
*/

SELECT
    *
FROM public.teachers t
ORDER BY t.teacher_id;

/*
 	Adding data
Write a following query:

Add a new class and assign it the newly-added teacher (main_teacher_id column).
Add 5 new students, assigning them to the new class (class_id column). Try to do this with a single SQL query.
*/

INSERT INTO public.classes (name, main_teacher_id)
VALUES ('IX C', 7);


/*
    Provera nove klase.
*/

SELECT
    *
FROM public.classes c
WHERE c.name = 'IX C';


/*
    Ovde ručno unosimo class_id nove klase.
    Umesto <class_id>, upiši class_id koji je dodeljen klasi IX C.
*/

INSERT INTO public.students (name, surname, email, class_id)
VALUES
    ('Mark',  'Brown', 'mark.brown@email.com', 7),
    ('Anna',  'White', 'anna.white@email.com', 7),
    ('David', 'Green', 'david.green@email.com', 7),
    ('Sara',  'Black', 'sara.black@email.com', 7),
    ('Tom',   'Gray',  'tom.gray@email.com',   7);


/*
    Finalna provera dodatih studenata.
*/

SELECT
    *
FROM public.students s
WHERE s.email IN (
    'mark.brown@email.com',
    'anna.white@email.com',
    'david.green@email.com',
    'sara.black@email.com',
    'tom.gray@email.com'
);
