extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const RUN_ROTATION = 0.00
const ROTATION_SPEED = 10.0
const CLIMB_SPEED = 75.0
const LIGHT_MASK_MULTIPLIER = 0.9999

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var selected_object: RigidBody2D = null
var light_mask_current = 1
var on_ladder = false
var is_climbing = false

enum State {
	IDLE,
	RUN,
	JUMP,
	LAND,
	SLICE,
	THROW,
	CLIMB,
	CLIMB_IDLE
}

var current_state = State.IDLE

func _ready():
	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.animation_finished.connect(_on_landing_animation_finished)

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

func _physics_process(delta):
	var mouse_position = get_global_mouse_position()
	if Input.is_action_pressed("ui_leftclick"):
		_lift_object(mouse_position)

	if on_ladder:
		_handle_climbing(delta)
	else:
		_handle_normal_movement(delta)
	
	move_and_slide()
	_update_animation_state()
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		
	if Input.is_action_just_pressed("interact"):
		pickup_item()

func _handle_climbing(delta):
	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	if input_vector != Vector2.ZERO:
		current_state = State.CLIMB
		$AnimatedSprite2D.play("climb")
		velocity = input_vector * CLIMB_SPEED
		is_climbing = true
		_play_climbing_sound()
	else:
		velocity = Vector2.ZERO
		current_state = State.CLIMB_IDLE
		$AnimatedSprite2D.stop()
		is_climbing = false
		_stop_climbing_sound()

	if Input.is_action_just_pressed("ui_accept"):
		_jump()

func _handle_normal_movement(delta):
	if not is_on_floor():
		if current_state != State.JUMP and on_ladder == false:
			$AnimatedSprite2D.play("jump")
			current_state = State.JUMP
		velocity.y += gravity * delta
		_stop_running_sound()

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			_handle_run(delta, direction < 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			_stop_running()

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		_jump()

func _jump():
	velocity.y = JUMP_VELOCITY
	$AnimatedSprite2D.play("jump")
	$JumpSound.play()
	_stop_running_sound()
	_stop_climbing_sound()
	current_state = State.JUMP
	on_ladder = false
	is_climbing = false

func _update_animation_state():
	if is_on_floor():
		if current_state == State.JUMP:
			$AnimatedSprite2D.play("land")
			current_state = State.LAND
		elif current_state == State.LAND and not $AnimatedSprite2D.is_playing():
			current_state = State.IDLE
			$AnimatedSprite2D.play("idle")

func _on_ladder_area_entered(_area):
	on_ladder = true
	_stop_running_sound()

func _on_ladder_area_exited(_area):
	on_ladder = false
	is_climbing = false
	_stop_climbing_sound()
	if not is_on_floor():
		current_state = State.JUMP
	else:
		current_state = State.IDLE

func _handle_run(delta, flip_h):
	if not on_ladder:
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = flip_h
		var target_rotation = RUN_ROTATION if not flip_h else -RUN_ROTATION
		$AnimatedSprite2D.rotation = lerp_angle($AnimatedSprite2D.rotation, target_rotation, delta * ROTATION_SPEED)
		current_state = State.RUN
		_play_running_sound()

func _play_running_sound():
	if not on_ladder and not $RunningSound.playing:
		$RunningSound.play()

func _stop_running():
	if $AnimatedSprite2D.animation == "run":
		$AnimatedSprite2D.play("idle")
		_stop_running_sound()

func _stop_running_sound():
	if $RunningSound.playing:
		$RunningSound.stop()

func _play_climbing_sound():
	if not $ClimbingSound.playing:
		$ClimbingSound.play()

func _stop_climbing_sound():
	if $ClimbingSound.playing:
		$ClimbingSound.stop()

func _on_landing_animation_finished():
	if current_state == State.LAND:
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
