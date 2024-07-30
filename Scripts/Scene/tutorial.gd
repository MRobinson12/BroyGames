extends Node2D
class_name BaseLevel

@export var level_name: String
@onready var pause_menu = %PauseMenu
@onready var dialogue_box = %DialogueBox
var paused = false

func _ready() -> void:
	dialogue_box.custom_effects[0].char_displayed.connect(_on_char_displayed)
	for child in get_children():
		if child is Area2D and child.is_in_group("level_transition"):
			child.connect("body_entered", _on_level_transition_body_entered.bind(child))
	paused = false
	pass

func _on_level_transition_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var target_level = $Area2D.get_meta("target_level")
		var target_entry = $Area2D.get_meta("target_entry", "SpawnPoint")
		get_tree().get_root().get_node("LevelHandler").change_level(target_level, target_entry)

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

func _on_char_displayed(idx):
	$Cats/DialogueBlip.play()

func hide_the_cats():
	$Cats/Cat2.hide()
	$Cats/Cat.hide()

func _on_dialogue_box_dialogue_signal(value: String) -> void:
	match(value):
		'hide_the_cats': hide_the_cats()
