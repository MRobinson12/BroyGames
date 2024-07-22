extends TabContainer

var item_list_entry = preload("res://Scenes/UI/item_list_entry.tscn")

var craft_list_entry = preload("res://Scenes/UI/crafting_list_entry.tscn")
var ingredient_entry = preload("res://Scenes/UI/ingredient_entry.tscn")
var recipe_dir = "res://Data/Recipes"
var dir = DirAccess.open(recipe_dir)

func _ready() -> void:
	GlobalData.home_inv_updated.connect(update_inventory)
	populate_crafting()

func update_inventory():
	refresh_crafting()
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
		
func refresh_crafting():
	for child in find_child("CraftingList").get_children():
		child.check_craft()

func populate_crafting():
	for child in find_child("CraftingList").get_children():
		child.queue_free()
	for file in dir.get_files():
		var recipe : CraftRecipe = load(recipe_dir + "/" + file)
		var new_craft = craft_list_entry.instantiate()
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
		$Crafting/VBoxContainer/ScrollContainer/CraftingList.add_child(new_craft)
