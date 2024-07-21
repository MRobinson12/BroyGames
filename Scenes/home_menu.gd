extends TabContainer

var item_list_entry = preload("res://Scenes/UI/item_list_entry.tscn")

func _ready() -> void:
	GlobalData.home_inv_updated.connect(update_inventory)

func update_inventory():
	for child in find_child("ItemList").get_children():
		child.queue_free()
	for item in GlobalData.home_inventory.contents:
		var new_item = item_list_entry.instantiate()
		var item_data = load("res://Data/Items/"+ str(item) + ".tres")
		new_item.find_child("IconTexture").set_texture(item_data.icon)
		new_item.find_child("NameLabel").text = item_data.name
		new_item.find_child("DescLabel").text = item_data.description
		new_item.find_child("QuantLabel").text = str(GlobalData.home_inventory.contents[item])
		$Inventory/ScrollContainer/ItemList.add_child(new_item)
