extends Area2D

func _ready() -> void:
	add_to_group("hazards")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("handle_death"):
		body.handle_death()
