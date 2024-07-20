extends Button

var test_item : Item = load("res://Data/Items/test_item.tres")
var test_item2 : Item = load("res://Data/Items/test_item2.tres")



func _on_pressed() -> void:
	GlobalData.player_inventory.add_item(test_item)
	GlobalData.player_inventory.add_item(test_item2)
