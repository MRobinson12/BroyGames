extends Node

func _ready():
	$VBoxContainer/Play.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/cave_level_tutorial.tscn")
	
func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")	

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")
