class_name InventoryDisplay
extends PanelContainer

@onready var grid_container : GridContainer = %GridContainer
var item_slot = preload("res://Scenes/UI/item_slot.tscn")

func _ready():
	create_slots()
	GlobalData.player_inv_updated.connect(update)

func update():
	for i in GlobalData.player_inventory.size():
		var slot = grid_container.get_child(i)
		slot.display(GlobalData.player_inventory.get_item(i))
		
func create_slots():
	for i in range(GlobalData.inventory_size):
		var new_slot = item_slot.instantiate()
		grid_container.add_child(new_slot)

func _on_toggle_inventory_pressed() -> void:
	update()
	if visible:
		hide()
	else:
		show()
