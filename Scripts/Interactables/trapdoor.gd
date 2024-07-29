extends DoorBase
class_name Trapdoor

func _ready():
	sprite = $TrapdoorSprite
	collision_shape = $CollisionShape2D
	super._ready()

func open():
	$TrapdoorOpen.play()
	super.open()
	
func close():
	$TrapdoorClose.play()
	super.close()
