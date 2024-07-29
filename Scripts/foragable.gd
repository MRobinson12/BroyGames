class_name Foragable
extends Pickup


@export var unpicked_sprite : Texture2D
@export var picked_sprite : Texture2D
var picked : bool = false


func _ready():
	$Unpicked.texture = unpicked_sprite
	$Unpicked.material.set_shader_parameter("enabled", int(shine))
	$Picked.texture = picked_sprite

func pick():
	picked = true
	$Unpicked.hide()
	$Picked.show()
