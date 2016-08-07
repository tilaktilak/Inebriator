from hal import init,give_hard,give_soft,go_home 
import time

class Ingredient:
	def __init__(self,name, position, category):
		self.name = name
		self.position = position
		self.category = category

class Dose:
	def __init__(self,ingredient,quantity):
		self.ingredient = ingredient
		self.quantity = quantity

### SOFT INGREDIENT
Coca = Ingredient('Coca',1,'Soft')
Eau = Ingredient('Eau',2,'Soft')
Orange = Ingredient('Orange',3,'Soft')

### HARD INGREDIENT
Whiskey = Ingredient('Whiskey',1,'Hard')
Rhum = Ingredient('Whiskey',2,'Hard')

### DOSES
D_Whiskey = Dose(Whiskey,1)
D_Rhum = Dose(Rhum,1)
D_Coca = Dose(Coca,7)
D_Orange = Dose(Orange,7)

### RECEIPES
R_Whiskey_Coca = [D_Whiskey,D_Coca]
R_Cuba_Libre = [D_Rhum,D_Coca]

def emergency_stop():
    print "In glass.py : Emergency STOP"
    init()

def choose_cocktail(cocktail_name):
    print "In choose_cocktail : Will prepare " + cocktail_name
    if(cocktail_name=="Whiskey_Coca"):
        make_cocktail(R_Whiskey_Coca)

def make_cocktail(receipe):
    print "In make_cocktail : Will do " + receipe
    init()
    for dose in receipe:
        if(dose.ingredient.category == 'Hard'):
            give_hard(dose.ingredient.position, dose.quantity)
        if(dose.ingredient.category == 'Soft'):
            give_soft(dose.ingredient.position,dose.quantity)
    go_home()
