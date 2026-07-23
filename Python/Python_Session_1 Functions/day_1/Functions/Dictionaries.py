# Dictionaries

"""
    Exercise 1
Write a user_data(first_name, last_name) that takes a name and surname as an argument and returns a dictionary based on the given keys and values:

"first_name" - as in the argument,
"last_name" - as in the argument,
"full_name" - composed of both arguments separated with space,
"initials" - first letters of both arguments followed by dots; both parts separated with space.
"""

def user_data(first_name, last_name):
    dict_user = {"first_name": first_name,
                 "last_name": last_name,
                 "full_name": first_name + ' ' + last_name,
                 "initials": first_name[0] + ' ' + last_name[0]}
    return dict_user

first = input("enter first name:\t")
last = input("enter last name:\t")

print(user_data(first, last))

"""
Exercise 2
Write a function display_dict(dictionary) 
that takes a dictionary argument and displays it in the way shown below.
"""

def display_dict(dictionary):
    for key, value in dictionary.items(): # prolazimo kroz recnik i izbacuje nam uredjeni par
        print(f"{key}:\t{value}")

dict_words = {'cat': 'Kot', 'dog': 'Pies', 'bird': 'Ptak'}

display_dict(dict_words)

# Keyword in

def wordfinder(words, word):
    if word in words:
        words.append("found")
    return words

words_lst = ['Twinkle', 'twinkle', 'little', 'star']
print(wordfinder(words_lst, 'star'))