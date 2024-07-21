class_name HomeInventory

var contents : Dictionary = {}


func get_item_quant(item : Item):
	if not contents.has(item.name):
		return 0
	return contents[item.name]
	
func add_item(item : Item):
	if contents.has(item.name):
		contents[item.name] = contents[item.name] + 1
	else:
		contents[item.name] = 1

func remove_item(item: Item):
	if not contents.has(item.name):
		return
	if contents[item.name] <= 0:
		contents.erase(item.name)
	contents[item.name] = contents[item.name] - 1
