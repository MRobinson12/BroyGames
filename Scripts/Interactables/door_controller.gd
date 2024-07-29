extends Node
class_name DoorController

@export var target_path: NodePath
@export var activator_paths: Array[NodePath]
@export var required_activations = 1

var target: DoorBase
var activators: Array
var active_count = 0

func _ready():
	target = get_node(target_path) as DoorBase
	if not target:
		push_error("Target must be a DoorBase or its subclass (Door, StoneDoor, or Trapdoor)")
		return

	for path in activator_paths:
		var activator = get_node(path)
		activators.append(activator)
		if activator.has_signal("toggled"):
			activator.connect("toggled", _on_activator_toggled)

func _on_activator_toggled(is_on):
	if is_on:
		active_count += 1
	else:
		active_count -= 1
	
	if active_count >= required_activations:
		target.open()
	else:
		target.close()

func add_activator(activator: Node):
	activators.append(activator)
	if activator.has_signal("toggled"):
		activator.connect("toggled", _on_activator_toggled)
