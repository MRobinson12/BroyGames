class_name InventoryDisplay
extends PanelContainer

@onready var grid_container : GridContainer = %GridContainer

func _ready():
	GlobalData.player_inv_updated.connect(update)

func update():
	for i in GlobalData.player_inventory.size():
		var slot = grid_container.get_child(i)
		slot.display(GlobalData.player_inventory.get_item(i))

func open():
	update()
	show()
	
func close():
	hide()
