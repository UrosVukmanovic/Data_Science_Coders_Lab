
import glob
import csv
import os

"""
Exercise 1

Write a letter_counter(text) function that takes a string as an argument 
and returns a dictionary with the string characters as keys and the number of occurrences as values.
"""

def letter_counter(text):
    counter = {}

    for letter in text:
        print(counter)
        if letter.lower() not in counter: # proveravamo da li se slovo ne nalazi u dict
            counter[letter.lower()] = 1 # ako se ne nalazi, stavljamo vrednost 1 (prvo pojavljivanje) # definisemo vrednost key:value
        else: counter[letter.lower()] = counter[letter.lower()] + 1 # ako ga vec pronadjemo kao kljuc u dict. povecavamo value za taj key:value pair za +1
    return counter 

str_text = 'Katharina'

print(f'{letter_counter(str_text)}\n')

"""
Exercise 2

Write a function,find_first_duplicate(text), that takes a string as an argument, 
and returns the first letter that, 
from its position until the end of string, appears more than once. 
If no letter repeats, the function should return None.
"""

def find_first_duplicate(text):

    for letter in text:
        if text.count(letter) > 1: # broji ponavljanje svakog slova u for petlji i ako kad se pojavi prvi duplikat odmah vraca to slovo
            return letter

text_strng = 'alibaba'

print(f'First duplicate in entered string is:\t{find_first_duplicate(text_strng)}\n')

def find_first_duplicate_2(txt):
    i = 0
    for c in txt:
        if c in txt[i+1:]:
            return c
        i += 1
    return None

txt_strng = "baba"

print(find_first_duplicate_2(txt_strng))

"""
Exercise 3

Instruction
In thearchive/ folder there are subfolders: 2018, 2019 and 2020, and inside each of them more subfolders with three-letter month-name abbreviations (jan, feb etc.).

Each of these folders contains .csv files (one per day of the month) with information on the number of new, returning and VIP customers who visited the store that day.

Write a script to sum up how many new, returning and VIP customers visited the shop in 2018, 2019 and 2020.

In 2018 the shop was visited by:
 - 853 new customers
 - 2842 returning customers
 - 315 VIP customers
In 2019 the shop was visited by:
 - 851 new customers
 - 2859 returning customers
 - 252 VIP customers
In 2020 the shop was visited by:
 - 757 new customers
 - 2767 returning customers
 - 255 VIP customers

"""

def files_in_year(year):
    return glob.glob(rf"C:\Users\UrosVukmanovic\CodersLab-Course-Python-Data-Analysis\Python Session_1\vs code\exercises\archive\{year}\**\*.csv", recursive = True)


years = (2018,2019,2020)

for year in years:
    filenames = files_in_year(year)
    print(f'Found {len(filenames)} CSV files for {year}')

    new = 0
    old = 0
    vip = 0
    
    for filename in filenames:
        with open(filename, newline = '') as my_files:
            report = csv.reader(my_files)
            data = list(report)
            new = new + int(data[0][1])
            old = old + int(data[1][1])
            vip = vip + int(data[2][1])

    print(f'in {year} the shop was visited by:\n\n- {new} new customers\n- {old} returning customers\n- {vip} vip customers\n')

    # II nacin

for year in [2018,2019,2020]:

    old = 0
    new = 0
    vip = 0

    for filepath in glob.glob(rf"C:\Users\UrosVukmanovic\CodersLab-Course-Python-Data-Analysis\Python Session_1\vs code\exercises\archive\{year}\*\*.csv", recursive = True):
        with open(filepath, newline = '') as file_x:               
            report = csv.reader(file_x)
            for row in report:
                if row[0] == "Nowi klienci":
                    new = new + int(row[1])
                if row[0] == "PowracajÄ…cy klienci":
                    old = old + int(row[1])
                if row[0] == "Klienci VIP":
                    vip = vip + int(row[1])
           
    """
           data = list(report)
            old = old + int(data[0][1])
            new = new + int(data[1][1])
            vip = vip + int(data[2][1])
    """
    print(f'in {year} the shop was visited by:\n\n- {new} new customers\n- {old} returning customers\n- {vip} vip customers\n')

"""
year = 2018
pattern = f"C:\\\\archive\\\\{year}\\\\**\\\\*.csv"
print('Pattern:', pattern)
print('Year folder exists?:', os.path.isdir(os.path.join("C:\\\\", 'archive', str(year))))
print('Archive folder listing (top 20) if exists:', os.listdir(os.path.join("C:\\\\", 'archive'))[:20] if os.path.isdir(os.path.join("C:\\\\", 'archive')) else 'no archive folder')
matches = glob.glob(pattern, recursive=True)
print('glob matches count:', len(matches))
print('first matches (up to 10):', matches[:10])

"""