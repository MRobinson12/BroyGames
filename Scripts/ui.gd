extends CanvasLayer

@onready var inventory_display : InventoryDisplay = %InventoryDisplay


func _on_toggle_inventory_pressed() -> void:
	if inventory_display.is_visible_in_tree():
		inventory_display.close()
	else:
		inventory_display.open()
