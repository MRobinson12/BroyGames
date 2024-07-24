extends DoorBase
class_name Door

@export var required_key_id: String

func _ready():
	sprite = $DoorSprite
	collision_shape = $CollisionShape2D
	super._ready()

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		check_player_inventory()
	
# check the players inventory for a key with the ID 
func check_player_inventory():
	for i in range(GlobalData.player_inventory.contents.size()):
		var item = GlobalData.player_inventory.contents[i]
		if item is KeyItem:
			if item.key_id == required_key_id:
				open()
				GlobalData.player_inventory.remove_item(i)
				return
			
