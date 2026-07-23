import psycopg2
import math

"""
    1. Calculating the average
Using Python calculate the average purchase price (buyPrice) of a product.

To do so:

Create a database connection object.
Query the database for all products (the query can be narrowed down to the purchase price).
In a loop, iterate all the results and sum them up.
After summing up all the results, divide them by the number of rows returned.
"""

connection = psycopg2.connect(
    host        = 'localhost',
    user        = 'postgres',
    password    = 'Btc_standard33!',
    dbname      = 'classicModels'
) # Pravimo konekciju sa bazom preko objekta (instance) connection

cursor = connection.cursor() # preko kursora i njegovih metoda radimo SQL upite u pythonu

cursor.execute("SELECT p.productname, p.buyprice FROM products p ") # SQL upite pisemo kao inline string (mozemo koristiti i f'string')

sum_price = 0
for row in cursor:
    sum_price += row[1] # posto sql upit  vraca tuple, pristupamo byprice tuple[1]

print(sum_price)
row_count = cursor.rowcount
print(f"row count = {row_count }")
print(f"Average price per product:\t{sum_price/row_count}")

cursor.close() 
connection.close() 

"""
    2. Min and max
Using Python and SQL, find out what the most expensive and cheapest product (based on the column MRSP - Manufacturers Suggested Retail Price) sold by the company.

To do so:

Create a database connection object.
Create variables for the highest and lowest price. Assign them values of 0 (for highest price) and math.inf (for lowest price). Remember to import the math library
Query the database for all products (the query may be narrowed down to just one column).
In a loop, iterate through all the results and:
If the product price is lower than the variable storing the lowest price, assign it to that variable;
If the price of the product is greater than the variable with the highest price, then assign that value to that variable.
At the end of the script, display information about these prices.
"""

connection = psycopg2.connect(
    host        = 'localhost',
    user        = 'postgres',
    password    = 'Btc_standard33!',
    dbname      = 'classicModels'
) 

cursor = connection.cursor() 

cursor.execute("""
                    SELECT
                       MSRP
                    FROM products
""")

max_price = -math.inf
min_price = math.inf

for price in cursor:
    current_price = price[0]
    if current_price < min_price:
        min_price = current_price
    if current_price > max_price:
        max_price = current_price

print(f"lowest price is:\t {min_price}\nhighest price is:\t{max_price}")
cursor.close()
connection.close()

