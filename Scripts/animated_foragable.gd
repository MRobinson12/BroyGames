class_name AnimatedForagable
extends Foragable

@export var sprite_frames : SpriteFrames


func _ready():
	$Unpicked.set_sprite_frames(sprite_frames)
	$Unpicked.material.set_shader_parameter("enabled", int(shine))
	$Unpicked.play("default")
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
