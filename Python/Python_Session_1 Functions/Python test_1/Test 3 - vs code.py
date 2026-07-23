# TEST 3 - PYTHON ZADACI

"""
   1. Napišite funkciju koja vraća veći broj od 2 proizvoljna cela broja.
"""

a = int(input("Enter number a:\t"))
b = int(input("Enter number b:\t"))

def max_of_two(x, y):
    return max(x,y)

max_of_two(a, b)

"""
   2. Napišite funkciju koja uzima listu brojeva i vraća njihovu srednju vrednost 
"""

def average_of_list(lst):
    if len(lst) == 0:
        return 0
    return sum(lst) / len(lst)

numbers = [1, 2, 3, 4, 5]
print(f'Srednja vrednost liste je:\t{average_of_list(numbers)}')

"""
3. Napišite funkciju koja proverava da li dati niz sadrži podreč `coder` ili `srb` i vraća 
odgovarajuću poruku. 
"""
# Resenje substring

def checking_substring(str_lst, substring1, substring2):
    found = [] # lista koja prima True vrednosti iz for petlje

    for element in str_lst:
        if substring1.lower().strip() in element.lower().strip(): # proveravamo da li se substring nalazi u elementu liste
            found.append(substring1) # ako se nalazi dodajemo u novu listu koju vracamo kao rezultat
        if substring2.lower().strip() in element.lower().strip():
            found.append(substring2)
    
    return found

list_of_words2 = ["coders_lab", "dog", "cat"]
substring1 = input("enter your first substring:\t")
substring2 = input("enter your second substring:\t")

result = checking_substring(list_of_words2, substring1, substring2)

if result:
    print(f"Found substring(s):\t{result} in list of words:\t{list_of_words2}")
else:
    print(f"No substrings found in the list of words:\t{list_of_words2}")


# Resenje string I
def check_string(s, word1, word2):
    if word1 in s and word2 in s:
        print(f'{word1.strip().lower()} and {word2.strip().lower()} are in the list of words\t{s}')
    elif word1 in s:
        print(f'{word1.strip().lower()} is in the list of words\t{s}')
    elif word2 in s:
        print(f'{word2.strip().lower()} is in the list of words\t{s}')
    else:
        print(f'Entered words {word1} and {word2} are not in the list of words:\t{s}')

list_of_words = ["dog", "cat", "srb"]
word1 = input("Enter your first word:\t")
word2 = input("Enter your second word:\t")

check_string(list_of_words, word1, word2)

"""
    Iako funkcija radi i ispituje dal se obe reci nalaze u listi reci ili se jedna rec nalazi u listi reci
    postoji bolji nacin da prvo napravimo listu od zadatih inputa
    pa onda da proveravamo da li se neki element iz liste inputa nalazi u listi reci i to na "python-skiji" nacin

"""
# Resenje string II

def check_string2(words, *inputs):
    found = [word for word in inputs if word in words] # pravimo listu za svaki word in inputs pod uslovom da se nalazi u zadatoj listi words

    if found:
        print(f"Found: {found} in {words}") # printamo samo rec koju smo nasli 
    else:
        print(f"No matches in {words}") # u zadatoj listi reci ne postoje unete reci

list_of_words = ["dog", "cat", "srb"]
word3 = input("Eneter your first word:\t")
word4 = input("Eneter your second word:\t")

check_string2(list_of_words, word3, word4)

"""
    4.  Napišite funkciju koja uzima listu brojeva i vraća rečnik sa brojem neparnih i parnih 
    vrednosti. 
"""

def par_nepar(number_list):
    result = {"parni":0, "neparni":0} # pravimo odmah recnik sa brojem parnih i neparnih brojeva u listi

    for i in number_list:
        if i % 2 == 0:
            result["parni"] += 1 # za svaki parni broj u listi, dodajemo +1 u recniku i to prema zadatom kljucu
        else:
            result["neparni"] += 1 # za svaki neparni broj u listi, dodajemo +1 u recniku i to prema zadatom kljucu
    return result # vracamo dobijeni recnik

list_of_numbers = [1,2,3,4,5,6,7,8,9,10]

result_dict = par_nepar(list_of_numbers) # rezultatu funckije (recnik) dodeljujemo varijablu

print(f'broj parnih brojeva u listi je:\t{result_dict["parni"]}\nbroj neparnih brojeva u listi je:\t{result_dict["neparni"]}')

# pomocu f string ispisujemo posebno broj parnih i neparnih brojeva tako sto pristupamo recniku pomocu kljuca


"""
    5. Napišite funkciju koja prihvata dve liste, jednu koja sadrži ključeve, a drugu 
        odgovarajuće vrednosti, i vraća rečnik kreiran uparivanjem elemenata sa dve liste. 
"""
# I Resenje

def create_dict(list_dict1, list_dict2):
    made_dict = {}
    for i in range(min(len(list_dict1), len(list_dict2))): # proveravamo koja lista ima manje elemenata i zadajemo taj broj za range, ako iterimao po vecem broju onda moze da se dogodi da nemamo dovoljno kljuceva i da pukne funkcija
        made_dict[list_dict1[i]] = list_dict2[i] # u nas dict ubacujem key value parove pomocu indeksa koji je isti za obe liste
    return made_dict
            
        

lst1 = ["dog", "cat", "snake"]
lst2 = ["wolf", "tiger", "mamba"]

result_dct = create_dict(lst1, lst2)
print(result_dct)

"""
    Komentar: Funkcija delimicno radi zato sto vraca uredjene key value parove, ali ne resava problem velicine listi i prikazivanja elemenata koji nemaju key value (ostatak)
"""
# II Resenje - preporuka za zip funckiju

def dct_creation(lst_dct1, lst_dct2):
    return dict(zip(lst_dct1, lst_dct2))

lst1_dct = ["dog", "cat", "snake"]
lst2_dct = ["wolf", "tiger", "mamba"]

result_dct_zip = dct_creation(lst1_dct, lst2_dct)
print(result_dct_zip)

"""
    Bonus zadatak (dodatno): Napišite funkciju koja proverava da li je dat niz palindrom.
    Palindrom je ako se pise isto od pocetka i od kraja (2p)
    Primer: za ulaz abbcbba ispisati balanced a za ulaz abcabac ispisati unbalanced
"""
     
def num_elements_list(num): # funkcija koja uzima broj elemenata za listu i prema tom broju stavljamo elemente u listu
    i = 1
    element_list = []
    while i <= num:
        element = input("enter element:\t")
        element_list.append(element)
        i+=1
    return element_list

num_elements = int(input("enter number of elements:\t"))   # broj elemenata u listi (za jos vecu sigurnost treba staviti uslov da broj elemenata mora da bude paran zato sto ako nije, onda funkcija palindrom nema smisla i uvek ce biti unbalanced)
result = num_elements_list(num_elements) # funkciju za unos elemenata u listu cuvamo kao varijablu koja ce biti argument za funkciju palindrom


def balanced(bal_list):
        print(bal_list)
        if  bal_list == bal_list[::-1]: # proveravamo da li se lista isto cita od pocetka i od kraja
            print("Balanced")
        else:
            print("Unbalanced")
        
balanced_parentheses = balanced(result)

# Pogresno sam protumacio bonus zadatak i radio sam funkciju za palindrom umesto balances parentheses

"""
    Bonus zadatak (dodatno): Napišite funkciju koja proverava da li je dat niz zagrada 
    “balansiran”. Niz zagrada je “balansiran” ako svaka otvorena zagrada ima 
    odgovarajuću zatvorenu zagradu u ispravnom redosledu. (2p)
    Primer: Za ulaz “()” ispisati tačno, dok za ulaz “({)” ispisati netačno.
"""

def balanced_parentheses(s):
    stack = []
    pairs = {')': '(', '}': '{', ']': '['}

    for char in s:
        if char in pairs.values():   # otvorene
            stack.append(char)

        elif char in pairs:          # zatvorene
            if not stack:
                return False

            if stack[-1] != pairs[char]:
                return False

            stack.pop()

    return not stack

print(balanced_parentheses("({[]})"))   # True
print(balanced_parentheses("({)}"))     # False
print(balanced_parentheses("((()))"))   # True
print(balanced_parentheses("(()"))      # False



