extends Area2D
class_name KeyPickup

@export var id : String
@onready var prompt = $InputPrompt

func _on_body_entered(body):
	if body is CharacterBody2D:
		prompt.show()

func _on_body_exited(body):
	if body is CharacterBody2D:
		prompt.hide()
