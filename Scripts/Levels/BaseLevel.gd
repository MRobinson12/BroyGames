extends Node2D
class_name BaseLevel

@export var level_name: String

func _ready() -> void:
	for child in get_children():
		if child is Area2D and child.is_in_group("level_transition"):
			child.connect("body_entered", _on_level_transition_body_entered.bind(child))

func _on_level_transition_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var target_level = $Area2D.get_meta("target_level")
		var target_entry = $Area2D.get_meta("target_entry", "SpawnPoint")
		get_tree().get_root().get_node("LevelHandler").change_level(target_level, target_entry)
