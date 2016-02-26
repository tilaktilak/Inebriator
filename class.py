from hal import set_angle 
import time


class Glass:
	""" the current glass object"""
	def __init__(self,level,position)
		self.level = level # Pourcent of fill
		self.position = position

	def fetch_dose(self,Dose):
            """ Check wich sens is faster (in step)"""
                if (self.position - Dose.ingredient.position)>100:
			sens = 1
		else :
			sens = 0
		set_angle(sens,self.position - Dose.ingredient.position)
		self.position = Dose.ingredient.position;

		if Dose.ingredient.category == 'Soft':
			## Enable Soft Pump
			time.sleep(Dose.quantity)
			## Disable Soft Pump
		else:
			""" Grow up glass	"""
			time.sleep(Dose.quantity)
			""" Grow down glass """
			self.level += Dose.quantity

	def make_cocktail(self,receipe):
            for dose in receipe:
                self.fetch_dose(self,Dose)

class Ingredient:
	def __init__(self,name, position, category):
		self.name = name
		self.position = position
		self.category = category

class Dose:
	def __init__(self,ingredient,quantity):
		self.ingredient = ingredient
		self.quantity = quantity

Coca = Ingredient('Coca',1,'Soft')
Eau = Ingredient('Eau',2,'Soft')
Orange = Ingredient('Orange',3,'Soft')
Whiskey = Ingredient('Whiskey',4,'Hard')

D_Whiskey = Dose(Whiskey,1)
D_Coca = Dose(Coca,7)
R_Whiskey_Coca = [D_Whiskey,D_Coca]

MyCup = Glass(0,0)

