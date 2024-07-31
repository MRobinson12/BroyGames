extends Area2D

var target_scene = "res://Scenes/home_scene.tscn"

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):   
	if body is CharacterBody2D:
		if target_scene:
			GlobalData.move_inventory()
			call_deferred("change_scene")
		else:
			print("Target scene is not set!")

func change_scene():
	get_tree().change_scene_to_file(target_scene)
