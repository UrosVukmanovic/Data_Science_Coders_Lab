# FILES

import os
import glob

"""
    Exercise 1
Open the poem.txt file and display 
its content prefixing each line with the string"line <LINE NUMBER>: ".

"""

with open(r'C:\Users\UrosVukmanovic\OneDrive - MDPI AG\Desktop\Coders Lab\Python Data Analysis\VS code Python\Session_1_-_exercise_files (1)\03_Day 2\Files\Exercise 1\poem.txt', 'r') as file:
    counter = 1
    for line in file:
        print(f"linija {counter}: {line}")
        counter += 1

"""
    Exercise 2
Open the tree.txt file in the write mode and write a 12-line-high tree in it. Use the for loop to generate the tree.

Expected file content:
"""

with open("tree.txt", "w") as my_text_file:
    for i in range(1, 13):
        my_text_file.write("*" * i + "\n")

"""
Exercise 3
Write a script that moves the files: one.txt and two.txt to the archive/ folder. 
The file names should remain the same, only the place where they are stored is to change.


os.replace(r'C:\\Users\\UrosVukmanovic\\OneDrive - MDPI AG\\Desktop\Coders Lab\Python Data Analysis\VS code Python\\Session_1_-_exercise_files (1)\03_Day 2\\Files\Exercise 3\\one.txt', 
           r'C:\\Users\\UrosVukmanovic\\OneDrive - MDPI AG\\Desktop\Coders Lab\Python Data Analysis\VS code Python\\Session_1_-_exercise_files (1)\03_Day 2\\Files\Exercise 3\\archive\\one.txt')
os.replace(r'C:\\Users\\UrosVukmanovic\\OneDrive - MDPI AG\\Desktop\Coders Lab\Python Data Analysis\VS code Python\\Session_1_-_exercise_files (1)\03_Day 2\\Files\Exercise 3\\two.txt', 
           r'C:\\Users\\UrosVukmanovic\\OneDrive - MDPI AG\\Desktop\Coders Lab\Python Data Analysis\VS code Python\\Session_1_-_exercise_files (1)\03_Day 2\\Files\Exercise 3\\archive\\two.txt')
"""


"""
Exercise 4
Find all files with a .txt extension in the data/ folder, using a loop open each of them and display its content on the screen.

The task will be correctly performed when you see three English palindromes on the screen, and zero Czech ones 
(because those are in .py files, not .txt files) and Ukrainian ones (those are in .html files).
"""

for file_path in glob.glob(r"C:\Users\UrosVukmanovic\OneDrive - MDPI AG\Desktop\Coders Lab\Python Data Analysis\VS code Python\Session_1_-_exercise_files (1)\03_Day 2\Files\Exercise 4\data\*.txt"):
    with open(file_path, 'r') as file:
        print(file.read())

