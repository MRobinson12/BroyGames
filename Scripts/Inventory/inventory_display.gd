class_name InventoryDisplay
extends PanelContainer

@onready var grid_container : GridContainer = %GridContainer

func _ready():
	GlobalData.inventory_updated.connect(update)

func update():
	for i in GlobalData.inventory.size():
		var slot = grid_container.get_child(i)
		slot.display(GlobalData.inventory.get_item(i))

func open():
	update()
	show()
	
func close():
	hide()
