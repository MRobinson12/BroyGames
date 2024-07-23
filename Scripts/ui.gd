extends CanvasLayer

@onready var inventory_display : InventoryDisplay = %InventoryDisplay
@onready var home_menu  = %HomeMenu
@onready var crafting_menu = %CraftingMenu

func _on_toggle_inventory_pressed() -> void:
	if inventory_display.is_visible_in_tree():
		inventory_display.close()
	else:
		inventory_display.open()


func _on_toggle_crafting_pressed() -> void:
	if home_menu.is_visible_in_tree():
		home_menu.hide()
		crafting_menu.show()
		crafting_menu.populate_crafting(home_menu.selected_recipes)
	else:
		home_menu.show()
		crafting_menu.hide()
