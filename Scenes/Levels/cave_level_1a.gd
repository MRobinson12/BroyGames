extends Node2D

@onready var dialogue_box = %DialogueBox
@onready var pause_menu = %PauseMenu
var paused = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue_box.custom_effects[0].char_displayed.connect(_on_char_displayed)
	$Cat/CatSprite.play("lore")
	paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
	else:
		pause_menu.show()
	
	paused = !paused

func _start_level_music():
	if not $"SecretsBehindTheCaverns(calmCavern)".is_playing():
		$"SecretsBehindTheCaverns(calmCavern)".play()
	
func _stop_level_music():
	if $"SecretsBehindTheCaverns(calmCavern)".is_playing():
		$"SecretsBehindTheCaverns(calmCavern)".stop()

func _start_hallway_music():
	if not $"WhatOnceWas(hallwayLore)".is_playing():
		$"WhatOnceWas(hallwayLore)".play()

func _stop_hallway_music():
	if $"WhatOnceWas(hallwayLore)".is_playing():
		$"WhatOnceWas(hallwayLore)".stop()


func _on_c_music_trigger_1_body_entered(body: Node2D) -> void:
	_stop_level_music()
	_start_hallway_music()

func _on_char_displayed(idx):
	$DialogueBlip.play()


func _on_c_music_trigger_2_body_entered(body: Node2D) -> void:
	_start_level_music()
	_stop_hallway_music()
