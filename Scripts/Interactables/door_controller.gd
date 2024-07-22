# DoorController.gd
extends Node

@export var target_path: NodePath
@export var lever_paths: Array[NodePath]
@export var required_activations = 1

var target: Node  # This can be either a Door or a Trapdoor
var levers: Array[Area2D]
var active_levers = 0

func _ready():
	target = get_node(target_path)
	for path in lever_paths:
		var lever = get_node(path)
		levers.append(lever)
		lever.connect("toggled", _on_lever_toggled)

func _on_lever_toggled(is_on):
	if is_on:
		active_levers += 1
	else:
		active_levers -= 1
	
	if active_levers >= required_activations:
		target.open()
	else:
		target.close()

# Function to add a new lever at runtime
func add_lever(lever: Area2D):
	levers.append(lever)
	lever.connect("toggled", _on_lever_toggled)

# Function to add a pressure plate (similar to a lever)
func add_pressure_plate(pressure_plate: Area2D):
	add_lever(pressure_plate)
