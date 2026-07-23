from selenium import webdriver

driver = webdriver.Chrome()

driver.get("https://www.google.com")

print(driver.title)

input("Pritisni Enter za zatvaranje...")
driver.quit()