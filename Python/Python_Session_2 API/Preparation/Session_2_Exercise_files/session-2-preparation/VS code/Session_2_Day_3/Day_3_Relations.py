import psycopg2


connection = psycopg2.connect(
	host='localhost',
	user='postgres',
	password='Btc_standard33!',
	dbname='classicModels'
)


def print_query(cursor):
	cols = [c[0] for c in cursor.description]
	for row in cursor:
		row_dict = dict(zip(cols, row))
		print(row_dict)


def main():
	cur = connection.cursor()

	# 1) load order id and status from orders
	cur.execute("""
		SELECT ordernumber AS order_id, status AS order_status
		FROM orders
		ORDER BY ordernumber
		LIMIT 10
	""")
	print('\n-- Step 1: orders (id + status)')
	print_query(cur)

	# 2) join with orderdetails to get product code and quantity
	cur.execute("""
		SELECT o.ordernumber AS order_id,
			   o.status AS order_status,
			   od.productcode AS product_code,
			   od.quantityordered AS quantity
		FROM orders o
		JOIN orderdetails od ON o.ordernumber = od.ordernumber
		ORDER BY o.ordernumber, od.productcode
		LIMIT 10
	""")
	print('\n-- Step 2: orders + orderdetails (add product code + quantity)')
	print_query(cur)

	# 3) join with products to add product name
	cur.execute("""
		SELECT o.ordernumber AS order_id,
			   o.status AS order_status,
			   od.productcode AS product_code,
			   od.quantityordered AS quantity,
			   p.productname AS product_name
		FROM orders o
		JOIN orderdetails od ON o.ordernumber = od.ordernumber
		JOIN products p ON od.productcode = p.productcode
		ORDER BY o.ordernumber, od.productcode
		LIMIT 20
	""")
	print('\n-- Step 3: orders + orderdetails + products (add product name)')
	print_query(cur)

	cur.close()


if __name__ == '__main__':
	try:
		main()
	finally:
		connection.close()


