# LIST & TUPLES

"""
Exercise 1
Write a create_list(a, b, c) function that takes three arguments of any type and 
then returns a list whose elements are the values of the arguments in the order of: a, b, c, b, a.
"""

def create_list(a, b, c):
    return [a, b, c, b, a]

print(create_list(1, 2, 3))

"""
Exercise 2
Write a histogram(list_of_integers) function,that loops through each digit in a list and displays the number of 
# characters equal to the digit – on a new line for each digit.
"""

def histogram(list_of_integers):
    result = []
    for num in list_of_integers:
        result.append("#" * num)
    return result

list_of_integers = [1,2,3,4,5]
print(histogram(list_of_integers))

def histogram(list_of_integers):
    for num in list_of_integers:
        print("#" * num)

histogram([1, 2, 3, 4, 5])

"""
Exercise 3
Write a function named find_short_words that takes a list of words 
This function should return a list of words shorter than 5 characters.
"""

def find_short_words(words):
    result = []
    for word in words:
        if len(word) < 5:
            result.append(word)
    return result

animal_list = ["cat", "dog", "elephant", "penguin"]

print(find_short_words(animal_list))

