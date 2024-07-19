extends Button

var test_item : Item = load("res://Data/Items/test_item.tres")



func _on_pressed() -> void:
	GlobalData.inventory.add_item(test_item)
