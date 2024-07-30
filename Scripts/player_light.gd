extends Node2D

var target_marker : Node2D
var lerp_speed = 3

var player_position : Vector2
var shadow_shader : ColorRect
var camera : Camera2D

@export var lights : Array[Node2D]
var light_positions : Array[Vector2]

func _ready():
	light_positions.resize(50)
	
	target_marker = get_parent().find_child("Player").find_child("LightPosition")
	shadow_shader = get_parent().get_node("ShaderLayer/PlayerVignette")
	camera = %Camera2D
	global_transform.origin = target_marker.global_transform.origin

func _process(delta: float):
	player_position = get_global_transform_with_canvas().get_origin() / Vector2(get_viewport().size)
	shadow_shader.material.set_shader_parameter("player_position",player_position)
	shadow_shader.material.set_shader_parameter("camera_zoom",camera.zoom.x)
	
	if not lights.is_empty():
		for i in range(lights.size()):
			light_positions[i] = lights[i].get_global_transform_with_canvas().get_origin() / Vector2(get_viewport().size)
		shadow_shader.material.set_shader_parameter("lights", light_positions)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	global_transform.origin = lerp(global_transform.origin, target_marker.global_transform.origin, delta * lerp_speed)
