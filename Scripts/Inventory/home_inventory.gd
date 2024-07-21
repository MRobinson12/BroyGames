class_name HomeInventory

var contents : Dictionary = {}


func get_item_quant(item : Item):
	if not contents.has(item.id):
		return 0
	return contents[item.id]
	
func add_item(item : Item):
	if contents.has(item.id):
		contents[item.id] = contents[item.id] + 1
	else:
		contents[item.id] = 1

func remove_item(item: Item):
	if not contents.has(item.id):
		return
	if contents[item.id] <= 0:
		contents.erase(item.id)
	contents[item.id] = contents[item.id] - 1
