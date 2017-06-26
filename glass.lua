
Ingredient= {name='unknown',position=0,category='unknown'}
function Ingredient:create(o,name,position,category)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Ingredient:settings(name,position,category)
	self.name = name
    self.position = position
	self.category = category
end


--### SOFT INGREDIENT
Coca = Ingredient:create()
Eau = Ingredient:create()
Orange = Ingredient:create()
Ananas = Ingredient:create()

Coca:settings('Coca',0,'Soft')
Eau:settings('Eau',7,'Soft')
Orange:settings('Orange',1,'Soft')
Ananas:settings('Ananas',2,'Soft')


--### HARD INGREDIENT
Rhum = Ingredient:create()
Tequila = Ingredient:create()
Grenadine = Ingredient:create()
Vodka = Ingredient:create()
Whiskey = Ingredient:create()

Rhum:settings('Rhum',2,'Hard')
Tequila:settings('Tequila',3,'Hard')
Grenadine:settings('Grenadine',4,'Hard')
Vodka:settings('Vodka',1,'Hard')
Whiskey:settings('Whiskey',1,'Hard')


Dose={ingredient=Coca,quantity=0}
function Dose:create(o,ingredient,quantity)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Dose:settings(ingredient,quantity)
	self.ingredient = ingredient
	self.quantity = quantity
end


--### DOSES
D_Whiskey = Dose:create()
D_Rhum = Dose:create()
D_Grenadine = Dose:create()
D_Tequila = Dose:create()
D_Vodka = Dose:create()

D_Whiskey:settings(Whiskey,5)
D_Rhum:settings(Rhum,5)
D_Grenadine:settings(Grenadine,0.001)
D_Tequila:settings(Tequila,5)
D_Vodka:settings(Vodka,5)

D_Coca = Dose:create()
D_Orange = Dose:create()
D_Ananas = Dose:create()
D_Orange_short = Dose:create()
D_Ananas_short = Dose:create()

D_Coca:settings(Coca,4)
D_Orange:settings(Orange,4)
D_Ananas:settings(Ananas,4)
D_Orange_short:settings(Orange,2)
D_Ananas_short:settings(Ananas,2)

--### RECEIPES
R_Whiskey_Coca = {D_Whiskey,D_Coca}
R_Cuba_Libre = {D_Rhum,D_Coca}
R_Punch = {D_Rhum,D_Orange}
R_Tequila_Sunrise = {D_Grenadine,D_Tequila,D_Orange}
R_Sex_On_The_Beach = {D_Grenadine,D_Vodka,D_Orange}
R_Punch_Planteur = {D_Grenadine,D_Rhum,D_Orange}
R_After_Glow = {D_Grenadine,D_Orange_short,D_Ananas_short}
R_Orange = {D_Orange}

function emergency_stop()
    print("In glass.py : Emergency STOP")
    init()
end

function make_cocktail(receipe)
    print("In make_cocktail : Will do the receipe")
    for k,dose in pairs(receipe) do
        print(" Dose : ")
        if(dose.ingredient.category == 'Hard') then
            print(dose.ingredient.name,
                    dose.ingredient.position,
                    dose.quantity)
            give_hard(dose.ingredient.position, dose.quantity)
        end
        if(dose.ingredient.category == 'Soft') then
            give_soft(dose.ingredient.position,dose.quantity)
        end        
    end
   go_home()
end

function print_cocktail(receipe)
    print("In make_cocktail : Will do the receipe")
    for k,v in pairs(receipe) do
        print(" Dose : ")
        if(v.ingredient.category == 'Hard') then
            print(v.ingredient.name)
            --give_hard(dose.ingredient.position, dose.quantity)
        end
        if(v.ingredient.category == 'Soft') then
            --give_soft(dose.ingredient.position,dose.quantity)
            print(v.ingredient.name)
        end        
    end
end
