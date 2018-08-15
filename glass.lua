
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

function Dose:copy(another)
    return Dose:create(another.ingredient, another.quantity)
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

-- recipes map
recipes = {}
recipes["Whiskey_Coca"] = R_Whiskey_Coca
recipes["Cuba_Libre"] = R_Cuba_Libre
recipes["Punch"] = R_Punch
recipes["Tequila_Sunrise"] = R_Tequila_Sunrise
recipes["Sex_On_The_Beach"] = R_Sex_On_The_Beach
recipes["Punch_Planteur"] = R_Punch_Planteur
recipes["After_Glow"] = R_After_Glow
recipes["Orange"] = R_Orange

function copy_recipe(recipe)
    copy = {}
    for i, dose in ipairs(recipe) do
        table.insert(copy, dose)
    end
    return copy
end

function emergency_stop()
    print("In glass.py : Emergency STOP")
    init()
end

function table_length(table)
    local count = 0
    for _ in pairs(table) do count = count + 1 end
    return count
end

function make_cocktail(original_recipe, give_hard_dose, give_soft_dose, reset, callback)
    -- takes two function wich serve doses based on position
    -- and quantity one for hard, the other for soft
    -- plus a reset for the machine and a callback when done
    local recipe = copy_recipe(original_recipe)
    local function make_cocktail_action(dose, next_actions)
        local function cocktail_action()
            if(dose.ingredient.category == 'Hard') then
                give_hard_dose(dose.ingredient.position, dose.quantity, next_actions)
            end
            if(dose.ingredient.category == 'Soft') then
                give_soft_dose(dose.ingredient.position,dose.quantity, next_actions)
            end
        end
        return cocktail_action
    end
    local function pile_up_recipe(next_actions)
        print('piling...')
        if (table_length(recipe) == 0) then
            return next_actions
        else
            dose = table.remove(recipe)
            print("pile up" .. dose.ingredient.name)
            return pile_up_recipe(make_cocktail_action(dose, next_actions))
        end
    end
    local function cocktail_last_action()
        reset(callback)
    end
    local cocktail_execution = pile_up_recipe(cocktail_last_action)
    cocktail_execution()
end
