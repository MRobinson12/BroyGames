class_name HomeInventory

var contents : Dictionary = {}


func get_item_quant(item : Item):
	if not contents.has(item.id):
		return 0
	return contents[item.id]
	
func add_item(item : Item):
	if contents.has(item.id):
		if item.id == "greendle":
			contents[item.id] = contents[item.id] + 3
		else:
			contents[item.id] = contents[item.id] + 1
	else:
		contents[item.id] = 1
	GlobalData.home_inv_updated.emit()

func remove_item(item: Item):
	if not contents.has(item.id):
		return
	contents[item.id] = contents[item.id] - 1
	if contents[item.id] <= 0:
		contents.erase(item.id)
	GlobalData.home_inv_updated.emit()
