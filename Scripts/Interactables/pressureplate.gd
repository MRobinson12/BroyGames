extends Area2D

signal toggled(is_on)

@export var is_on = false
@onready var sprite = $PressureplateSprite

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	update_appearance()

func _on_body_entered(body):
	if body.is_in_group("WoodenCrate") and not is_on:
		toggle()

func _on_body_exited(body):
	if body.is_in_group("WoodenCrate") and is_on:
		toggle()

func toggle():
	is_on = !is_on
	emit_signal("toggled", is_on)
	update_appearance()

func update_appearance():
	if is_on:
		sprite.play("plate_depressed")
	else:
		sprite.play("plate_idle")
