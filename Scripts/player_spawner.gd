extends Node2D
class_name SpawnPoint

@export var player_scene: PackedScene
var player_instance: CharacterBody2D = null

func _ready() -> void:
	if player_scene:
		player_instance = player_scene.instantiate()
		player_instance.set_spawn_point(self)
		player_instance.global_position = $SpawnMarker.global_position
		get_parent().add_child.call_deferred(player_instance)
		player_instance.player_died.connect(_on_player_died)
		print("Player spawned at position: ", player_instance.global_position)
	else:
		push_error("Player scene not set!")

func _on_player_died():
	await get_tree().create_timer(1.0).timeout
	player_instance.respawn()
