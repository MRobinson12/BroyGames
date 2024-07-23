extends Node2D

var target_marker : Node2D
var lerp_speed = 3

var player_position : Vector2
var shadow_shader : ColorRect
var camera : Camera2D

func _ready():
	target_marker = get_parent().find_child("Player").find_child("LightPosition")
	shadow_shader = get_parent().get_node("ShaderLayer/PlayerVignette")
	camera = %Camera2D
	global_transform.origin = target_marker.global_transform.origin

func _process(delta: float):
	player_position = get_global_transform_with_canvas().get_origin() / Vector2(get_viewport().size)
	shadow_shader.material.set_shader_parameter("player_position",player_position)
	shadow_shader.material.set_shader_parameter("camera_zoom",camera.zoom.x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	global_transform.origin = lerp(global_transform.origin, target_marker.global_transform.origin, delta * lerp_speed)
