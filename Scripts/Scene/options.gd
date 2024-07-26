extends Node

#Function to pull the current set BGM Music from Global Manager
var bgmvolume = BgmManager.get_volume

func _ready():
	$Return.grab_focus()
	#NEED THIS TO UPDATE TO REFLECT CURRENT SET VALUE - WILL BREAK
	$VBoxContainer/MusicVol.value(bgmvolume)

func _on_music_vol_value_changed(volume: float):
	BgmManager.update_bgm_music_vol(volume)

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
