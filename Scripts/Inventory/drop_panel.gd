extends Panel

@onready var player = %Player
var item_pickup = preload("res://Scenes/item_pickup.tscn")

func _can_drop_data(_at_position, _index):
	return true
	
func _drop_data(_at_position, index):
	var new_pickup = item_pickup.instantiate()
	new_pickup.set_item(GlobalData.player_inventory.get_item(index))
	new_pickup.set_shine(true)
	get_tree().root.add_child(new_pickup)
	new_pickup.global_transform.origin = player.get_node("DropPosition").global_transform.origin
	
	GlobalData.player_inventory.remove_item(index)
