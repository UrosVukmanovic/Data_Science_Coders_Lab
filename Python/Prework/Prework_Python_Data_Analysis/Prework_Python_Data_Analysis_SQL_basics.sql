/*
	Remember to put the solutions to the assignments (SQL queries) in a text file, which you will then send to your mentor.

Write the following queries:

A query finding all students,
A query finding all teachers,
A query finding only first names of students,
A query finding only surnames and emails of students,
*/

SELECT 
	s.student_id ,
	s."name" ,
	s.surname 
FROM public.students s;

--

SELECT 
	t.teacher_id,
	t."name" 
FROM public.teachers t;

--

SELECT 
	s."name"
FROM public.students s;

--

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
The last query already starts using the relationships between our tables. First we found out what ID Bryan has, then using that we loaded all the marks he gave.

In this course, we will show you how to use relationships in a simpler way.
 */

SELECT 
    s.student_id,
    s."name",
    s.surname
FROM public.students s
WHERE s."name" LIKE 'A%';

--

SELECT 
    t.teacher_id,
    t."name",
    t.pay
FROM public.teachers t
WHERE t.pay > 1900;

--

SELECT
    m.mark_id,
    m.student_id,
    m.teacher_id,
    m.mark
FROM public.marks m
WHERE m.mark > 4;

--

SELECT
    t.teacher_id,
    t."name"
FROM public.teachers t
WHERE t."name" = 'Bryan Cubes'

--

SELECT
    m.mark_id,
    m.student_id,
    m.teacher_id,
    m.mark
FROM public.marks m
WHERE m.teacher_id = 3 

/*
 	AND and OR clauses
Write a following query:

A query finding the data of a student whose name is Damian and surname is Forrester,
A query finding Damian Forrester's marks higher than 3,
All students with names starting from D or B.
 */

SELECT
    s.student_id,
    s."name",
    s.surname,
    s.email
FROM public.students s
WHERE s."name" = 'Damian'
  AND s.surname = 'Forrester';

--

SELECT
    m.mark_id,
    m.mark,
    s."name",
    s.surname
FROM public.marks m
INNER JOIN public.students s
    ON m.student_id = s.student_id
WHERE s."name" = 'Damian'
  AND s.surname = 'Forrester'
  AND m.mark > 3;

--

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

SELECT
    m.mark_id,
    m.mark,
    t."name"
FROM public.marks m
INNER JOIN public.teachers t
    ON m.teacher_id = t.teacher_id
WHERE t."name" = 'Clara Oakley'
ORDER BY m.mark DESC;

--

SELECT
    s.student_id,
    s."name",
    s.surname
FROM public.students s
ORDER BY s.surname ASC;

--

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

INSERT INTO public.teachers ("name", pay)
VALUES ('John Koval', 1300);

SELECT
	*
FROM public.teachers t 

/*
 	Adding data
Write a following query:

Add a new class and assign it the newly-added teacher (main_teacher_id column).
Add 5 new students, assigning them to the new class (class_id column). Try to do this with a single SQL query.
*/

SELECT 
	*
FROM public.classes c 

INSERT INTO public.students (name, surname, email, class_id)
SELECT 
    s.name,
    s.surname,
    s.email,
    c.class_id
FROM (
    SELECT 'Mark' AS name, 'Brown' AS surname, 'mark.brown@email.com' AS email
    UNION ALL
    SELECT 'Anna', 'White', 'anna.white@email.com'
    UNION ALL
    SELECT 'David', 'Green', 'david.green@email.com'
    UNION ALL
    SELECT 'Sara', 'Black', 'sara.black@email.com'
    UNION ALL
    SELECT 'Tom', 'Gray', 'tom.gray@email.com'
) AS s
JOIN public.classes c
ON TRUE
WHERE c.name = "IX C"

SELECT 
	*
FROM public.students s 
