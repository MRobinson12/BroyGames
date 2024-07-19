class_name Inventory

var contents : Array[Item]
var null_item : Item
var inventory_size = 12

func _init():
	print("test")
	null_item = load("res://Data/Items/null_item.tres")
	
	contents.resize(inventory_size)
	contents.fill(null_item)

func size():
	return contents.size()

func get_contents():
	return contents
	
func get_item(index):
	return contents[index]

func get_index(item : Item):
	return contents.find(item)

func add_item(item : Item):
	for i in range(contents.size()):
		if contents[i].name == "null":
			place_item(item, i)
			return
	GlobalData.inventory_updated.emit(self)

func place_item(item : Item, index):
	contents[index] = item
	GlobalData.inventory_updated.emit(self)

func remove_item(index):
	contents[index] = null_item
	GlobalData.inventory_updated.emit(self)
