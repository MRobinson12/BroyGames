extends Node2D
class_name PlayerLevelTransition

@export var target_level: String
@export var target_entry: String = "SpawnPoint"

signal change_level(target_level, target_entry)

func _ready() -> void:
	$Area2D.connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("change_level", target_level, target_entry)
