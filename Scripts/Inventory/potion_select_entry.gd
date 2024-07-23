extends HBoxContainer

var recipe : CraftRecipe
@onready var check_box : CheckBox = $CheckBox

func check_craft():
	for input in recipe.inputs:
		if GlobalData.home_inventory.get_item_quant(input.item) < input.quant:
			check_box.disabled = true
			return
	check_box.disabled = false
