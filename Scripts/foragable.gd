class_name Foragable
extends Pickup

@export var unpicked_sprite : Texture2D
@export var picked_sprite : Texture2D
var picked : bool = false
var player_in_range : bool = false


func _ready():
	$Unpicked.texture = unpicked_sprite
	$Unpicked.material.set_shader_parameter("enabled", int(shine))
	$Picked.texture = picked_sprite

func pick():
	picked = true
	$Unpicked.hide()
	$Picked.show()
	prompt.hide()

func _on_body_entered(body):
	if body is CharacterBody2D:
		player_in_range = true
		if not picked:
			prompt.show()

func _on_body_exited(body):
	if body is CharacterBody2D and not picked:
		player_in_range = false
		if not picked:
			prompt.hide()
