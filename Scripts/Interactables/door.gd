extends DoorBase
class_name Door

@export var required_key_id: String

var player_in_range: bool = false

func _ready():
	sprite = $DoorSprite
	collision_shape = $CollisionShape2D
	super._ready()
	$InteractionArea.connect("body_entered", _on_body_entered)
	$InteractionArea.connect("body_exited", _on_body_exited)

func _process(_delta):
	if Input.is_action_just_pressed("interact") and player_in_range:
		check_player_inventory()

func _on_body_entered(_body):
	player_in_range = true

func _on_body_exited(_body):
	player_in_range = false

# Check the player's inventory for a key with the ID 
func check_player_inventory():
	for i in range(GlobalData.player_inventory.contents.size()):
		var item = GlobalData.player_inventory.contents[i]
		if item is KeyItem and item.key_id == required_key_id:
			open()
			GlobalData.player_inventory.remove_item(i)
			# Add door open sound here
			return
	# Add door rattle sound here
