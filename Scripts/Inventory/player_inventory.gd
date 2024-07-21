class_name PlayerInventory

var contents : Array[Item]
var null_item : Item
var inventory_size = 12

func _init():
	null_item = load("res://Data/Items/null_item.tres")
	
	contents.resize(inventory_size)
	contents.fill(null_item)

func size():
	return contents.size()

func get_contents():
	return contents
	
func get_item(index : int):
	return contents[index]

func add_item(item : Item):
	for i in range(contents.size()):
		if contents[i].name == "null":
			place_item(item, i)
			return
	GlobalData.player_inv_updated.emit()

func place_item(item : Item, index : int):
	contents[index] = item
	GlobalData.player_inv_updated.emit()
	
func swap_items(item1_index : int, item2_index : int):
	var temp_item = contents[item1_index]
	contents[item1_index] = contents[item2_index]
	contents[item2_index] = temp_item
	GlobalData.player_inv_updated.emit()

func remove_item(index : int):
	contents[index] = null_item
	GlobalData.player_inv_updated.emit()
	
func reset():
	for i in range(size()):
		contents[i] = null_item
