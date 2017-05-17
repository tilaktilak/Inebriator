
Ingredient= {name='unknown',position=0,category='unknown'}
function Ingredient:create(o,name,position,category)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
	self.name = name
    self.position = position
	self.category = category
    return o
end

--### SOFT INGREDIENT
Coca = Ingredient:create(nil,'Coca',1,'Soft')
Eau = Ingredient:create(nil,'Eau',7,'Soft')
Orange = Ingredient:create(nil,'Orange',2,'Soft')
Ananas = Ingredient:create(nil,'Ananas',3,'Soft')


--### HARD INGREDIENT
Rhum = Ingredient:create(nil,'Rhum',2,'Hard')
Tequila = Ingredient:create(nil,'Tequila',3,'Hard')
Grenadine = Ingredient:create(nil,'Grenadine',4,'Hard')
Vodka = Ingredient:create(nil,'Vodka',5,'Hard')
Whiskey = Ingredient.create(nil,'Whiskey',6,'Hard')


Dose={ingredient=Coca,quantity=0}
function Dose:create(o,ingredient,quantity)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
	self.ingredient = ingredient
	self.quantity = quantity
    return o
end


### DOSES
D_Whiskey = Dose.create(nil,Whiskey,5)
D_Rhum = Dose.create(nil,Rhum,5)
D_Grenadine = Dose.create(nil,Grenadine,0.01)
D_Tequila = Dose.create(nil,Tequila,5)
D_Vodka = Dose.create(nil,Vodka,5)

D_Coca = Dose.create(nil,Coca,4)
D_Orange = Dose.create(nil,Orange,4)
D_Ananas = Dose.create(nil,Ananas,4)
D_Orange_short = Dose.create(nil,Orange,3)
D_Ananas_short = Dose.create(nil,Ananas,3)

### RECEIPES
R_Whiskey_Coca = [D_Whiskey,D_Coca]
R_Cuba_Libre = [D_Rhum,D_Coca]
R_Punch = [D_Rhum,D_Orange]
R_Tequila_Sunrise = [D_Grenadine,D_Tequila,D_Orange]
R_Sex_On_The_Beach = [D_Grenadine,D_Vodka,D_Orange]
R_Punch_Planteur = [D_Grenadine,D_Rhum,D_Orange]
R_After_Glow = [D_Grenadine,D_Orange_short,D_Ananas_short]

function emergency_stop()
    print "In glass.py : Emergency STOP"
    init()
end

function  choose_cocktail(cocktail_name)
    print "In choose_cocktail : Will prepare " + cocktail_name
    if(cocktail_name=="whiskycoca") then
        make_cocktail(R_Whiskey_Coca)
    end
    if(cocktail_name=="cubalibre") then
        make_cocktail(R_Cuba_Libre)
    end
    if(cocktail_name=="punch") then
        make_cocktail(R_Punch)
    end
    if(cocktail_name=="tequilasunrise") then
        make_cocktail(R_Tequila_Sunrise)
    end
    if(cocktail_name=="sexonthebeach") then
        make_cocktail(R_Sex_On_The_Beach)
    end
    if(cocktail_name=="afterglow") then
        make_cocktail(R_After_Glow)
    end
    if(cocktail_name=="punchplanteur") then
        make_cocktail(R_Punch_Planteur)
    end
end

function make_cocktail(receipe)
    print "In make_cocktail : Will do the receipe"
    init()
    for dose in receipe do
        print " Dose : "
        if(dose.ingredient.category == 'Hard') then
            give_hard(dose.ingredient.position, dose.quantity)
        end
        if(dose.ingredient.category == 'Soft') then
            give_soft(dose.ingredient.position,dose.quantity)
        end        
    end
    #init()
    #go_home()
    init()
 end
