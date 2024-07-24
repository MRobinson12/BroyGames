extends DoorBase
class_name Door

@export var required_key_id: String

func _ready():
	sprite = $DoorSprite
	collision_shape = $CollisionShape2D
	super._ready()

func try_open(key_id: String) -> bool:
	if key_id == required_key_id:
		open()
		return true
	return false
