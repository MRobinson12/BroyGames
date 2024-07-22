extends Area2D

signal toggled(is_on)

@export var is_on = false
@onready var sprite = $PressureplateSprite

var box_in_range = false

func _ready():
	# change body entered to box
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	update_appearance()

func _process(delta):
	if box_in_range:
		toggle()

func _on_body_entered(body):
	box_in_range = true

func _on_body_exited(body):
	box_in_range = false

func toggle():
	is_on = !is_on
	emit_signal("toggled", is_on)
	update_appearance()

func update_appearance():
	if is_on:
		sprite.play("lever_on")
	else:
		sprite.play("lever_off")
