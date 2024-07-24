extends StaticBody2D
class_name DoorBase

signal state_changed(is_open)

@export var is_open = false
@onready var sprite: AnimatedSprite2D = null
@onready var collision_shape: CollisionShape2D = null

func _ready():
	update_state()

func open():
	is_open = true
	update_state()

func close():
	is_open = false
	update_state()

func update_state():
	if sprite and collision_shape:
		if is_open:
			sprite.play("door_open")
			collision_shape.set_deferred("disabled", true)
		else:
			sprite.play("door_closed")
			collision_shape.set_deferred("disabled", false)
	
	emit_signal("state_changed", is_open)
