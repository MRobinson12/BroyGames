extends Node2D

@onready var dialogue_box = %DialogueBox
@export var dialogue_id : String
var player_in_range : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CatSprite.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_range:
		if Input.is_action_just_pressed("interact"):
			dialogue_box.start(dialogue_id)


func _on_body_entered(body):
	if body is CharacterBody2D:
		player_in_range = true
		$InputPrompt.show()

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		$InputPrompt.hide()
