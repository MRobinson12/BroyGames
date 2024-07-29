extends Node
class_name DoorController

@export var target_paths: Array[NodePath]
@export var activator_paths: Array[NodePath]
@export var required_activations = 1

var targets: Array[DoorBase] = []
var activators: Array = []
var active_count = 0

func _ready():
	for path in target_paths:
		var target = get_node(path) as DoorBase
		if target:
			targets.append(target)
		else:
			push_error("Target must be a DoorBase or its subclass (Door, StoneDoor, or Trapdoor)")
	
	for path in activator_paths:
		var activator = get_node(path)
		activators.append(activator)
		if activator.has_signal("toggled"):
			activator.connect("toggled", _on_activator_toggled)
	
	# Initialize active_count based on initial state of activators
	for activator in activators:
		if activator.is_on:
			active_count += 1
	
	# Update door states based on initial active_count
	update_door_states()

func _on_activator_toggled(is_on):
	if is_on:
		active_count += 1
	else:
		active_count -= 1
	
	update_door_states()

func update_door_states():
	for target in targets:
		if active_count >= required_activations:
			if not target.is_open:
				target.open()
		else:
			if target.is_open:
				target.close()

func add_activator(activator: Node):
	activators.append(activator)
	if activator.has_signal("toggled"):
		activator.connect("toggled", _on_activator_toggled)
	if activator.is_on:
		active_count += 1
		update_door_states()
