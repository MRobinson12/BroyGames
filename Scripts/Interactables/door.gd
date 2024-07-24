extends DoorBase
class_name Door

@export var required_key_id: String

func _ready():
	sprite = $DoorSprite
	collision_shape = $CollisionShape2D
	super._ready()

# check the players inventory for a key with the ID 
# HEY JOSSSHHHHH
func check_player_inventory():
	for item in GlobalData.player_inventory.contents:
		if item is KeyItem:
			if item.key_id == required_key_id:
				open()
				return
			
