class_name PlayerInventory

var contents : Array[Item]
var null_item : Item
var inventory_size : int
var is_full : bool

func init():
	null_item = load("res://Data/Items/null_item.tres")
	
	contents.resize(inventory_size)
	contents.fill(null_item)
	check_full()

func size():
	return contents.size()

func get_contents():
	return contents
	
func get_item(index : int):
	return contents[index]
	
func check_full():
	for i in range(contents.size()):
		if contents[i].name == "null":
			is_full = false
			return
	is_full = true

func add_item(item : Item):
	for i in range(contents.size()):
		if contents[i].name == "null":
			place_item(item, i)
			return
	GlobalData.player_inv_updated.emit()
	check_full()

func place_item(item : Item, index : int):
	contents[index] = item
	GlobalData.player_inv_updated.emit()
	check_full()
	
func swap_items(item1_index : int, item2_index : int):
	var temp_item = contents[item1_index]
	contents[item1_index] = contents[item2_index]
	contents[item2_index] = temp_item
	GlobalData.player_inv_updated.emit()
	check_full()

func remove_item(index : int):
	contents[index] = null_item
	GlobalData.player_inv_updated.emit()
	check_full()
	
func reset():
	for i in range(size()):
		contents[i] = null_item
	GlobalData.player_inv_updated.emit()
	check_full()
