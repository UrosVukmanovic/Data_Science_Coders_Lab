import psycopg2
import math

"""
1. Aggregate functions in SQL
Find out the following from the database:

1. What is the size of each order (by size, we mean the number of pieces of all products in that order)?
2. What is the total amount of each order?
3. How many products are there for each product line?
4. What is the average suggested retail price (MSRP) for each product line?
5. How many customers are from each country?
6. What is the smallest and largest credit limit for a company per country?
Hint:
In point 2 we can calculate the amount for the order using sum(quantityordered * priceEach).
Such code is going to multiply quantityordered and priceEach for each row, and then sum them up.
"""
# 1 What is the size of each order (by size, we mean the number of pieces of all products in that order)?
connection = psycopg2.connect(
    user = 'postgres',
    password = 'Btc_standard33!',
    host = 'localhost',
    dbname = 'classicModels'
)

cursor = connection.cursor()

cursor.execute("""
               SELECT
	                od.ordernumber,
	                SUM(od.quantityordered) 
                FROM orderdetails od
                GROUP BY od.ordernumber 
                ORDER BY SUM(od.quantityordered) DESC
""")

cols = [c[0] for c in cursor.description]
for row in cursor:
    row_dict = dict(zip(cols, row))
    print(row_dict)

cursor.close()

# 2 What is the total amount of each order?

cursor = connection.cursor()

cursor.execute("""

SELECT
	od.ordernumber,
	SUM(od.quantityordered * od.priceeach) AS total_price
FROM orderdetails od
GROUP BY od.ordernumber 
ORDER BY total_price DESC
""")

for row in cursor:
    print(row)

cursor.close()

# 3 How many products are there for each product line?

cursor = connection.cursor()

cursor.execute("""

SELECT
	COUNT(p.productcode),
	p.productline 
FROM products p
GROUP BY p.productline 
""")

for row in cursor:
    print(row)

cursor.close()

# 4 What is the average suggested retail price (MSRP) for each product line?

cursor = connection.cursor()

cursor.execute("""

SELECT
	p.productline,
	AVG(p.msrp )
FROM products p 
GROUP BY p.productline  
""")

for row in cursor:
    print(row)

cursor.close()

# 5 How many customers are from each country?

cursor = connection.cursor()

cursor.execute("""

SELECT
	c.country,
	COUNT(c.customernumber)
FROM customers c
GROUP BY c.country  
""")

for row in cursor:
    print(row)

cursor.close()

# 6 What is the smallest and largest credit limit for a company per country?

cursor = connection.cursor()

cursor.execute("""

SELECT
	c.country, 
	MAX(c.creditlimit) AS max_crd_limit,
	MIN(c.creditlimit) AS min_crd_limit
FROM customers c 
GROUP BY  
		c.country  
""")

for row in cursor:
    print(row)

cursor.close()

"""
Multiple grouping
Multiple grouping
It is also possible to group by multiple columns. The result will always be grouped in the order in which the columns are entered (from left to right).

For example, if you want to find out how many orders in each status are assigned to each company, you can create a SQL query:

SELECT customerName, status, count(status) FROM customers
JOIN orders ON orders.customernumber = customers.customernumber
GROUP BY customername, status
ORDER BY customername;

Based on this query, find out, how many employees with a particular jobtitle are in each office.
"""
cursor = connection.cursor()

cursor.execute("""

SELECT 
	e.jobtitle,
	e.officecode,
	COUNT(e.employeenumber)
FROM employees e 
GROUP BY 
	e.jobtitle,
	e.officecode   
""")

cols = [c[0] for c in cursor.description]
for row in cursor:
    row_dict = dict(zip(cols, row))
    print(row_dict)


"""# open the csv file for writing
csv_file = open('file.csv', mode='w')
users = csv.writer(csv_file, delimiter=';', quotechar='"')
 
# write data to file
for row in cursor:
    users.writerow(row)

cursor.close()


cols = [c[0] for c in cursor.description]
rows = cursor.fetchall()

with open('file.csv', mode='w', newline='', encoding='utf-8') as csv_file:
    writer = csv.writer(csv_file, delimiter=';', quotechar='"')
    writer.writerow(cols)          # zaglavlje
    writer.writerows(rows)         # svi rezultati odjednom

cursor.close()
"""

