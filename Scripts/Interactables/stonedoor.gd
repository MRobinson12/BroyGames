extends DoorBase
class_name StoneDoor

func _ready():
	sprite = $StonedoorSprite
	collision_shape = $CollisionShape2D
	super._ready()
	
func open():
	$StonedoorOpen.play()
	super.open()
	
func close():
	$StonedoorClosed.play()
	super.close()
