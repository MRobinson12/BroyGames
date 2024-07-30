extends CanvasLayer

var main
@onready var player = %Player

func _ready():
	main = get_tree().root.get_child(1)

func _on_resume_pressed() -> void:
	main.pauseMenu()

func _on_quit_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_respawn_pressed():
	if player:
		player.respawn()
		main.pauseMenu()  # Unpause the game after respawning
	else:
		print("Player not found!")
