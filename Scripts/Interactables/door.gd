extends DoorBase
class_name Door

signal door_opened(door_id)

@export var required_key_id: String
@export var door_id: String

var player_in_range = false

func _ready():
	sprite = $DoorSprite
	collision_shape = $CollisionShape2D
	$InteractionArea.connect("body_entered", Callable(self, "_on_body_entered"))
	$InteractionArea.connect("body_exited", Callable(self, "_on_body_exited"))
	super._ready()

func _process(_delta):
	if player_in_range == true:
		if Input.is_action_just_pressed("interact"):
			check_player_inventory()

func _on_body_entered(body):
	if body is CharacterBody2D:
		player_in_range = true

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false

func check_player_inventory():
	for i in range(GlobalData.player_inventory.contents.size()):
		var item = GlobalData.player_inventory.contents[i]
		if item.name == required_key_id:
			GlobalData.player_inventory.remove_item(i)
			$DoorOpen.play()
			open()
			emit_signal("door_opened", door_id)  # Emit the signal when the door is opened
			return
	$DoorRattle.play()
