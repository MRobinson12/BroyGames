extends TabContainer

var selected_recipes : Array[CraftRecipe]
var max_potion_slots : int = 3

var item_list_entry = preload("res://Scenes/UI/item_list_entry.tscn")

var potion_select_entry = preload("res://Scenes/UI/potion_select_entry.tscn")
var ingredient_entry = preload("res://Scenes/UI/ingredient_entry.tscn")
var recipe_dir = "res://Data/Recipes"
var dir = DirAccess.open(recipe_dir)

func _ready() -> void:
	GlobalData.home_inv_updated.connect(update_inventory)
	populate_potions()

func update_inventory():
	refresh_potions()
	for child in find_child("ItemList").get_children():
		child.queue_free()
	for item in GlobalData.home_inventory.contents:
		var new_item = item_list_entry.instantiate()
		var item_data = load("res://Data/Items/"+ str(item) + ".tres")
		new_item.find_child("IconTexture").set_texture(item_data.icon)
		new_item.find_child("NameLabel").text = item_data.name
		new_item.find_child("DescLabel").text = item_data.description
		new_item.find_child("QuantLabel").text = str(GlobalData.home_inventory.contents[item])
		$Inventory/ScrollContainer/ItemList.add_child(new_item)
		
func refresh_potions():
	for child in find_child("PotionList").get_children():
		child.check_craft()
		
func potion_selected(_value):
	selected_recipes.clear()
	for child in find_child("PotionList").get_children():
		if child.find_child("CheckBox").button_pressed == true:
			selected_recipes.append(child.recipe)
	if selected_recipes.size() >= max_potion_slots:
		disable_selection()
	else:
		enable_selection()
		refresh_potions()

func enable_selection():
	for child in find_child("PotionList").get_children():
		child.find_child("CheckBox").disabled = false

func disable_selection():
	for child in find_child("PotionList").get_children():
		if child.find_child("CheckBox").button_pressed == false:
			child.find_child("CheckBox").disabled = true

func populate_potions():
	for child in find_child("PotionList").get_children():
		child.queue_free()
	for file in dir.get_files():
		var recipe : CraftRecipe = load(recipe_dir + "/" + file)
		var new_craft = potion_select_entry.instantiate()
		new_craft.recipe = recipe
		new_craft.find_child("IconTexture").set_texture(recipe.output.item.icon)
		new_craft.find_child("NameLabel").text = recipe.output.item.name
		new_craft.find_child("DescLabel").text = recipe.output.item.description
		new_craft.find_child("QuantLabel").text = str(recipe.output.quant)
		for input in recipe.inputs:
			var new_input = ingredient_entry.instantiate()
			new_input.find_child("IconTexture").set_texture(input.item.icon)
			new_input.find_child("NameLabel").text = input.item.name
			new_input.find_child("QuantLabel").text = str(input.quant)
			new_craft.find_child("IngredientList").add_child(new_input)
		new_craft.find_child("CheckBox").toggled.connect(potion_selected)
		$"Potion Select/VBoxContainer/ScrollContainer/PotionList".add_child(new_craft)
