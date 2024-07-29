extends Area2D
class_name Pickup

@export var item : Item
@export var shine : bool = true

func _ready() -> void:
	$Sprite2D.texture = item.icon
	$Sprite2D.material.set_shader_parameter("enabled", int(shine))

func set_item(new_item : Item):
	item = new_item
	$Sprite2D.texture = item.icon

func set_shine(val : bool):
	shine = val
