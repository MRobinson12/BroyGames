extends HBoxContainer

var recipe : CraftRecipe


func check_craft():
	for input in recipe.inputs:
		if GlobalData.home_inventory.get_item_quant(input.item) < input.quant:
			$CraftButton.disabled = true
			return
	$CraftButton.disabled = false

func _on_craft_button_pressed() -> void:
	for input in recipe.inputs:
		for i in range(input.quant):
			GlobalData.home_inventory.remove_item(input.item)
	GlobalData.potion_crafted.emit(recipe.output.item)
