extends Area2D

@export var key_id: String

var player_in_range = false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	
func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		#insert inventory logic here
		queue_free()

func _on_body_entered(body):
	player_in_range = true

func _on_body_exited(body):
	player_in_range = false
