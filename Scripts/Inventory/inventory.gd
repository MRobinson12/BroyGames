class_name Inventory

var contents : Array[Item] = []

func size():
	return contents.size()

func get_contents():
	return contents
	
func get_item(index):
	return contents[index]

func add_item(item : Item):
	contents.append(item)

func remove_item(item : Item):
	contents.erase(item)
