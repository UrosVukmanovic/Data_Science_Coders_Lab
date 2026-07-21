# FUNCTIONS


"""
1. Exercise 1
Write a multiply(a, b) function, 
that returns the result of multiplication of two numbers passed to it.
"""


a = int(input("enter number a:\t"))
b = int(input("enter number b:\t"))
def multiply(a, b):
    result = a * b
    return result

print(f"result of multiply function is:\t{multiply(a, b)}")


"""
2. Exercise 2
Write a power(base, exponent) function that takes two arguments and returns the result of: 
argument base to the power of exponent.

Write a root(number, degree) function that calculates the degree-th root for the number. 
Let the root degree be the number 2 by default.
"""
def power_function (a, b):
    result = a ** b
    return result

a = int(input("enter number a:\t"))
b = int(input("enter number b:\t"))
print(f"result of power function is:\t{power_function(a, b)}")

def root_function (a, b = 2):
    result = a ** (1 / b)
    return result

a = int(input("enter number a:\t"))
b = int(input("enter number b:\t"))
print(f"result of root function is:\t{root_function(a, b)}")

"""
3. Exercise 3
Write an is_even(number) function that takes a number and returns True if the number is even, and False if it is not.

Write an is_odd(number) function, that takes a number and returns True, if the number is odd, and False otherwise. 
You can calculate the result (as in the is_even function) or use the is_even function in the code of the is_odd function.
"""

def is_even(number):
    return number % 2 == 0

def is_odd(number):
    return number % 2 != 0

print(is_even(4))  
print(is_even(5)) 

print(is_odd(4))   
print(is_odd(5))