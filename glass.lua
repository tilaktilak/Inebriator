
Ingredient = {}

function create_ingredient(name, position, category)
    return {
       name=name,
       position=position,
       category=category
    }
end

-- SOFT INGREDIENT
Coca = create_ingredient('Coca',3,'Soft')
Eau = create_ingredient('Eau',7,'Soft')
Orange = create_ingredient('Orange',1,'Soft')
Ananas = create_ingredient('Ananas',2,'Soft')

-- HARD INGREDIENT
Vodka = create_ingredient('Vodka',1,'Hard')
Rhum = create_ingredient('Rhum',2,'Hard')
Tequila = create_ingredient('Tequila',3,'Hard')
Grenadine = create_ingredient('Grenadine',4,'Hard')
Whiskey = create_ingredient('Whiskey',5,'Hard')

Dose = {}

function create_dose(ingredient,quantity)
    return {
	    ingredient = ingredient,
	    quantity = quantity
    }
end

function copy_dose(another)
    return create_dose(another.ingredient, another.quantity)
end

-- doses
D_Rhum = create_dose(Rhum,5)
D_Grenadine = create_dose(Grenadine,0.001)
D_Tequila = create_dose(Tequila,5)
D_Vodka = create_dose(Vodka,5)

D_Coca = create_dose(Coca,4)
D_Orange = create_dose(Orange,4)
D_Ananas = create_dose(Ananas,4)
D_Orange_short = create_dose(Orange,2)
D_Ananas_short = create_dose(Ananas,2)

-- recipes map
recipes = {}
recipes["Whiskey_Coca"] = {D_Whiskey, D_Coca}
recipes["Cuba_Libre"] = {D_Rhum, D_Coca}
recipes["Punch"] = {D_Rhum, D_Orange}
recipes["Tequila_Sunrise"] = {D_Grenadine, D_Tequila, D_Orange}
recipes["Sex_On_The_Beach"] = {D_Grenadine, D_Vodka, D_Orange}
recipes["Punch_Planteur"] = {D_Grenadine, D_Rhum, D_Orange}
recipes["After_Glow"] = {D_Grenadine, D_Orange_short, D_Ananas_short}
recipes["Orange"] = {D_Orange}

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
	    print("Cocktail Action : "..dose.ingredient.name .. dose.ingredient.category)
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
