extends Node

const bgm = preload("res://Audio/OST/Down the Hatch (Main Theme).mp3")

func _ready():
	$VBoxContainer/Return.grab_focus()

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
