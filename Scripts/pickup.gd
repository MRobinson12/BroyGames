extends Area2D
class_name Pickup

@export var item : Item
@export var shine : bool

func _ready() -> void:
	$Sprite2D.texture = item.icon
	$Sprite2D.material.set_shader_parameter("enabled", int(shine))
