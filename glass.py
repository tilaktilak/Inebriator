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
Eau = Ingredient('Eau',7,'Soft')
Orange = Ingredient('Orange',2,'Soft')
Ananas = Ingredient('Ananas',3,'Soft')


### HARD INGREDIENT
Rhum = Ingredient('Rhum',2,'Hard')
Tequila = Ingredient('Tequila',3,'Hard')
Grenadine = Ingredient('Grenadine',4,'Hard')
Vodka = Ingredient('Vodka',5,'Hard')
Whiskey = Ingredient('Whiskey',6,'Hard')

### DOSES
D_Whiskey = Dose(Whiskey,5)
D_Rhum = Dose(Rhum,5)
D_Grenadine = Dose(Grenadine,0.01)
D_Tequila = Dose(Tequila,5)
D_Vodka = Dose(Vodka,5)

D_Coca = Dose(Coca,4)
D_Orange = Dose(Orange,4)
D_Ananas = Dose(Ananas,4)
D_Orange_short = Dose(Orange,3)
D_Ananas_short = Dose(Ananas,3)

### RECEIPES
R_Whiskey_Coca = [D_Whiskey,D_Coca]
R_Cuba_Libre = [D_Rhum,D_Coca]
R_Punch = [D_Rhum,D_Orange]
R_Tequila_Sunrise = [D_Grenadine,D_Tequila,D_Orange]
R_Sex_On_The_Beach = [D_Grenadine,D_Vodka,D_Orange]
R_Punch_Planteur = [D_Grenadine,D_Rhum,D_Orange]
R_After_Glow = [D_Grenadine,D_Orange_short,D_Ananas_short]

def emergency_stop():
    print "In glass.py : Emergency STOP"
    init()

def choose_cocktail(cocktail_name):
    print "In choose_cocktail : Will prepare " + cocktail_name
    if(cocktail_name=="whiskycoca"):
        make_cocktail(R_Whiskey_Coca)
    if(cocktail_name=="cubalibre"):
        make_cocktail(R_Cuba_Libre)
    if(cocktail_name=="punch"):
        make_cocktail(R_Punch)
    if(cocktail_name=="tequilasunrise"):
        make_cocktail(R_Tequila_Sunrise)
    if(cocktail_name=="sexonthebeach"):
        make_cocktail(R_Sex_On_The_Beach)
    if(cocktail_name=="afterglow"):
        make_cocktail(R_After_Glow)
    if(cocktail_name=="punchplanteur"):
        make_cocktail(R_Punch_Planteur)

def make_cocktail(receipe):
    print "In make_cocktail : Will do the receipe"
    init()
    for dose in receipe:
        print " Dose : "
        if(dose.ingredient.category == 'Hard'):
            give_hard(dose.ingredient.position, dose.quantity)
        if(dose.ingredient.category == 'Soft'):
            give_soft(dose.ingredient.position,dose.quantity)
        #init()
    #go_home()
    init()
