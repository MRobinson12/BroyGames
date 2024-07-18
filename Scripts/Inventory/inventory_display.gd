class_name InventoryDisplay
extends PanelContainer

@onready var grid_container : GridContainer = %GridContainer

func update(inventory : Inventory):
	for i in inventory.size():
		var slot = grid_container.get_child(i)
		slot.display(inventory.get_item(i))

func open(inventory : Inventory):
	update(inventory)
	show()
	
func close():
	hide()


func _on_data_manager_inventory_updated(inventory) -> void:
	update(inventory)
