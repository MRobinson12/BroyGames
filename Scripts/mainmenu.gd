extends Node

@onready var bgm = preload("res://Audio/OST/Down the Hatch (Main Theme).mp3")

func _ready():
	BgmManager.play_song_chosen(bgm)
	$VBoxContainer/Play.grab_focus()

func _on_play_pressed() -> void:
	BgmManager.stop()
	get_tree().change_scene_to_file("res://Scenes/test_scene.tscn")

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
