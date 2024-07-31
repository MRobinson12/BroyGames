extends PanelContainer

var craft_list_entry = preload("res://Scenes/UI/crafting_list_entry.tscn")
var ingredient_entry = preload("res://Scenes/UI/ingredient_entry.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalData.home_inv_updated.connect(refresh_crafting)
	

func refresh_crafting():
	for child in find_child("CraftingList").get_children():
		child.check_craft()

func populate_crafting(recipes : Array[CraftRecipe]):
	for child in find_child("CraftingList").get_children():
		child.queue_free()
	for recipe in recipes:
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
		$MarginContainer/ScrollContainer/CraftingList.add_child(new_craft)
	refresh_crafting()
