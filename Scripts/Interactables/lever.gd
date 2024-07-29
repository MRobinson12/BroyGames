extends Area2D

signal toggled(is_on)

@export var is_on = false
@onready var sprite = $LeverSprite

var player_in_range = false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	update_appearance()

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		toggle()

func _on_body_entered(body):
	player_in_range = true

func _on_body_exited(body):
	player_in_range = false

func toggle():
	is_on = !is_on
	emit_signal("toggled", is_on)
	$LeverSound.play()
	update_appearance()

func update_appearance():
	if is_on:
		sprite.play("lever_on")
	else:
		sprite.play("lever_off")
