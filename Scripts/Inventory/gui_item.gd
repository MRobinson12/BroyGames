extends TextureRect

func _get_drag_data(_pos):
	var slot_index = get_parent().get_index()
	var item = GlobalData.inventory.get_item(slot_index)
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
	
func _can_drop_data(_pos, item):
	return true
	
func _drop_data(_pos, old_index):
	var item = GlobalData.inventory.contents[old_index]
	GlobalData.inventory.remove_item(old_index)
	var slot_index = get_parent().get_index()
	GlobalData.inventory.place_item(item, slot_index)
