extends DoorBase
class_name StoneDoor

func _ready():
	sprite = $StonedoorSprite
	collision_shape = $CollisionShape2D
	super._ready()
