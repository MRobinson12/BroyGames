extends Area2D

signal toggled(is_on)

@export var is_on = false
@onready var sprite = $PressureplateSprite

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	update_appearance()

func _on_body_entered(body):
	if (body.is_in_group("WoodenCrate") or body.is_in_group("Player")) and not is_on:
		$PressurePlatePressed.play()
		toggle()

func _on_body_exited(body):
	if (body.is_in_group("WoodenCrate") or body.is_in_group("Player")) and is_on:
		# Check if there are still valid bodies on the pressure plate
		var bodies = get_overlapping_bodies()
		var still_pressed = false
		for overlapping_body in bodies:
			if overlapping_body.is_in_group("WoodenCrate") or overlapping_body.is_in_group("Player"):
				still_pressed = true
				break
		
		if not still_pressed:
			$PressurePlateReleased.play()
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
