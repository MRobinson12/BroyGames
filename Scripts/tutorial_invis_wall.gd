extends StaticBody2D

@export var door_id: String
@export var door_path: NodePath  # Path to the door node

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initial state of the wall, assuming it's enabled
	set_collision_enabled(true)

	# Get the door node
	var door = get_node(door_path)
	if door:
		# Connect the door's signal to the invisible wall's method
		door.connect("door_opened", Callable(self, "on_door_opened"))

func set_collision_enabled(enabled: bool):
	$CollisionShape2D.disabled = not enabled

# Method to be called when the door is opened
func on_door_opened(opened_door_id: String):
	if opened_door_id == door_id:
		set_collision_enabled(false)
