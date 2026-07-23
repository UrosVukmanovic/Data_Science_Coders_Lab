# TEXTSTRING

"""
    Exercise 1
Write a create_email(first_name, last_name) function that generates an email address in the myamazingcompany.com domain. The username should be created from the arguments: first letter of first name, period, last name - all in lowercase.

Example:
"""

def create_email(first_name, last_name):
    print(f"{first_name[0].strip().lower()}.{last_name.strip().lower()}@myamazingcompany.com")

firstname = input("enter your first name:\t")
lastname = input("enter your lastn name:\t")

create_email(firstname, lastname)

"""
    Exercise 2
Write a create_address(first_name, last_name, street, number, city, zipcode) function that generates a nicely formatted address 
"""

def create_address(first_name, last_name, street,number, city, zipp_code):
    print(f"deliver to: {first_name} {last_name}\naddress: {street} {number}\n{zipp_code} {city}")

create_address('John', 'Connor', 'Hayvenhurst Drive', 12, 'Van Nyus', '14329')

"""
    Exercise 3
Write a function anonymize(email), that takes an email address as an argument, and returns a text consisting of:

the first three characters in an email address
three asterisks: '***'
the last five characters in an email address
If the address is less than 10 characters long, the function should return a text consisting of:

three asterisks: '***'
the last five characters in an email address
"""

def anonymize(email):
    if len(email) < 10:
        print(f" {email[:2]} *** {email[-5:]}")
    print(f"*** {email[-5:]}")

mail = input("enter your email:\t")

anonymize(mail)

"""
    
Exercise 4
Write a reverse_str(text) 
function that takes a string argument and returns it written in reverse order.
"""

def reverse_str(text):
    print(text[::-1])

reverse_str("abcd")
