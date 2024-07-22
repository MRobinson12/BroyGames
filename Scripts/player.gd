extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const RUN_ROTATION = 0.00
const ROTATION_SPEED = 10.0
const LIGHT_MASK_MULTIPLIER = 0.9999

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")	
var selected_object: RigidBody2D = null
var light_mask_current = 1

enum State {
	IDLE,
	RUN,
	JUMP,
	LAND,
	SLICE,
	THROW
}

var current_state = State.IDLE
var player_position : Vector2
var shadow_shader : ColorRect
var camera : Camera2D

func _ready():
	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.animation_finished.connect(_on_landing_animation_finished)
	shadow_shader = get_parent().get_node("ShaderLayer/PlayerVignette")
	camera = get_parent().get_node("Camera2D")

func pickup_item():
	var items_in_range = $PickupArea.get_overlapping_areas()
	if not items_in_range.is_empty():
		var nearest_item = null
		var shortest_distance = INF
		for item in items_in_range:
			if item is Pickup:
				var distance = position.distance_squared_to(item.position)
				if distance < shortest_distance:
					nearest_item = item
					shortest_distance = distance
		if nearest_item != null:
			GlobalData.player_inventory.add_item(nearest_item.item)
			nearest_item.queue_free()
			
func _process(delta):
	player_position = get_global_transform_with_canvas().get_origin() / Vector2(get_viewport().size)
	shadow_shader.material.set_shader_parameter("player_position",player_position)
	shadow_shader.material.set_shader_parameter("camera_zoom",camera.zoom.x)
	
func _physics_process(delta):
	var mouse_position = get_global_mouse_position()
	if Input.is_action_pressed("ui_leftclick"):
		_lift_object(mouse_position)	
	if current_state != State.JUMP:
		if Input.is_action_pressed("ui_right") and is_on_floor():
			_handle_run(delta, false)
			if sign($Marker2D.position.x) == -1:
				$Marker2D.position.x *= -1
		elif Input.is_action_pressed("ui_left") and is_on_floor():
			_handle_run(delta, true)
			if sign($Marker2D.position.x) == 1:
				$Marker2D.position.x *= -1
		else:
			$AnimatedSprite2D.rotation = lerp_angle($AnimatedSprite2D.rotation, 0, delta * ROTATION_SPEED)
			if $AnimatedSprite2D.animation != "idle" and $AnimatedSprite2D.animation != "jump" and $AnimatedSprite2D.animation != "land":
				$AnimatedSprite2D.play("idle")
				current_state = State.IDLE
				_stop_running_sound()
				
		if $AnimatedSprite2D.is_playing() == false and is_on_floor():
			$AnimatedSprite2D.play("idle")
			current_state = State.IDLE
		
		if Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
			_stop_running()
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")
		$JumpSound.play()
		_stop_running_sound()
		current_state = State.JUMP
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# Check if on the floor to reset state
	if is_on_floor():
		if current_state == State.JUMP:
			$AnimatedSprite2D.play("land")
			current_state = State.LAND
		elif current_state == State.LAND and not $AnimatedSprite2D.is_playing():
			current_state = State.IDLE
			
	if Input.is_action_pressed("ui_cancel"):
			get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
			
	if Input.is_action_just_pressed("interact"):
		pickup_item()

func _handle_run(delta, flip_h):
	$AnimatedSprite2D.play("run")
	$AnimatedSprite2D.flip_h = flip_h
	var target_rotation = RUN_ROTATION if not flip_h else -RUN_ROTATION
	$AnimatedSprite2D.rotation = lerp_angle($AnimatedSprite2D.rotation, target_rotation, delta * ROTATION_SPEED)
	current_state = State.RUN
	_play_running_sound()

func _play_running_sound():
	if not $RunningSound.is_playing():
		$RunningSound.play()

func _stop_running():
	if $AnimatedSprite2D.animation == "run":
		$AnimatedSprite2D.play("idle")
		_stop_running_sound()

func _stop_running_sound():
	if $RunningSound.is_playing():
		$RunningSound.stop()
		
func _on_landing_animation_finished():
	if current_state == State.LAND:
		$AnimatedSprite2D.disconnect("animation_finished", Callable(self, "_on_landing_animation_finished"))
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			current_state = State.RUN
		else:
			current_state = State.IDLE

func _lift_object(mouse_position: Vector2):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_position
	var result = space_state.intersect_point(query)
	
	if result.size() > 0:
		var selected = result[0]
		if selected.collider is RigidBody2D:
			if selected_object and selected.collider.name != selected_object.name:
				selected_object.set_collision_mask_value(2, true)
				selected_object.set_collision_mask_value(3, true)
				selected_object.set_collision_layer_value(3, true)
				selected_object.set_linear_damp(0)
				selected_object = selected.collider
			else:
				selected_object = selected.collider
	if selected_object:
		selected_object.set_collision_mask_value(2, false)
		selected_object.set_collision_mask_value(3, false)
		selected_object.set_collision_layer_value(3, false)
		_move_object(mouse_position, selected_object)

func _move_object(mouse_position: Vector2, selected_object: RigidBody2D):
	var object_position = selected_object.position
	var direction = mouse_position - object_position
	var distance = direction.length()
	direction = direction.normalized()
	var max_force_magnitude = 700.0
	var min_force_magnitude = 10.0
	var decrease_distance = 5.0
	var force_magnitude = max(min_force_magnitude, max_force_magnitude * (distance / decrease_distance))
	var linear_damping_level = max(0, 4 * (distance / decrease_distance))
	selected_object.set_linear_damp(linear_damping_level)
	selected_object.apply_force(direction * force_magnitude)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if selected_object:
			selected_object.set_collision_mask_value(2, true)
			selected_object.set_collision_mask_value(3, true)
			selected_object.set_collision_layer_value(3, true)
			selected_object.set_linear_damp(0)
		selected_object = null
