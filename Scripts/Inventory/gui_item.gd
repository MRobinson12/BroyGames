extends TextureRect

func _get_drag_data(_pos):
	var slot_index = get_parent().get_index()
	var item = GlobalData.player_inventory.get_item(slot_index)
	if item.name == "null":
		return
	
	var drag_texture = TextureRect.new()
	drag_texture.expand_mode = true
	drag_texture.texture = texture
	drag_texture.size = Vector2(50,50)
	
	var control = Control.new()
	control.add_child(drag_texture)
	drag_texture.position = -0.5 * drag_texture.size
	
	set_drag_preview(control)
	
	return slot_index
	
func _can_drop_data(_pos, _index):
	return true
	
func _drop_data(_pos, old_index):
	var slot_index = get_parent().get_index()
	GlobalData.player_inventory.swap_items(old_index, slot_index)
