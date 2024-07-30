extends CharacterBody2D

@onready var pickup_prompt = $PickupPrompt

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const LIGHT_MASK_MULTIPLIER = 0.9999
const CLIMB_SPEED = 75.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")	
var selected_object: RigidBody2D = null
var light_mask_current = 1
var current_run_anim = null
var current_idle_anim = null
var on_ladder = false
var is_climbing = false
var spawn_point: Vector2

enum State {
	IDLE,
	RUN,
	JUMP,
	LAND,
	CLIMB,
	CLIMB_IDLE,
	DEATH
}

var current_state = State.IDLE

func _ready():
	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.animation_finished.connect(_on_landing_animation_finished)
	set_spawn_point()
	
func _physics_process(delta):
	var mouse_position = get_global_mouse_position()

	# Assign correct animations dependant on whether there is a currently focused object for telekinesis
	if selected_object:
		current_idle_anim = "idleTele"
		current_run_anim = "runTele"
	else:
		_stop_telekinesis_sound()
		current_idle_anim = "idle"
		current_run_anim = "run"

	if Input.is_action_pressed("ui_leftclick"):
		_lift_object(mouse_position)
	if Input.is_action_just_pressed("ui_leftclick"):
		$AnimatedSprite2D.play("idleTele")

	if Input.is_action_just_released("ui_leftclick"):
		if selected_object:
			selected_object.set_collision_mask_value(2, true)
			selected_object.set_collision_mask_value(3, true)
			selected_object.set_collision_layer_value(3, true)
			selected_object.set_linear_damp(0)
			selected_object = null
		$AnimatedSprite2D.play("idle")
		
	if on_ladder:
		_handle_climbing(delta)
	else:
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
				if $AnimatedSprite2D.animation != "idle" and $AnimatedSprite2D.animation != "jump" and $AnimatedSprite2D.animation != "land" and $AnimatedSprite2D.animation != "idleTele":
					$AnimatedSprite2D.play(current_idle_anim)
					current_state = State.IDLE
					_stop_running_sound()
				
			if $AnimatedSprite2D.is_playing() == false and is_on_floor():
				$AnimatedSprite2D.play(current_idle_anim)
				current_state = State.IDLE
		
			if Input.is_action_just_released("ui_right") or Input.is_action_just_released("ui_left"):
				_stop_running()
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if selected_object:
			Input.action_release("ui_leftclick")
			selected_object.set_collision_mask_value(2, true)
			selected_object.set_collision_mask_value(3, true)
			selected_object.set_collision_layer_value(3, true)
			selected_object.set_linear_damp(0)
			selected_object = null
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")
		$JumpSound.play()
		_stop_running_sound()
		_stop_climbing_sound()
		current_state = State.JUMP
		on_ladder = false
		is_climbing = false
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
			
	#get nearest item
	var items_in_range = $PickupArea.get_overlapping_areas()
	var nearest_item = null
	if not items_in_range.is_empty():
		var shortest_distance = INF
		for item in items_in_range:
			if item is Pickup or item is KeyPickup:
				var distance = position.distance_squared_to(item.position)
				if distance < shortest_distance:
					nearest_item = item
					shortest_distance = distance
	if nearest_item != null:
		if nearest_item is Foragable:
			pickup_prompt.global_position = Vector2(nearest_item.global_position.x - 10, nearest_item.global_position.y)
		else:
			pickup_prompt.global_position = Vector2(nearest_item.global_position.x - 10, nearest_item.global_position.y - 10)
		pickup_prompt.show()
	else:
		pickup_prompt.hide()
	
	#pickup item
	if Input.is_action_just_pressed("interact"):
		if nearest_item != null:
			if nearest_item is Foragable and not nearest_item.picked:
				GlobalData.player_inventory.add_item(nearest_item.item)
				nearest_item.pick()
			elif nearest_item is KeyPickup:
				var new_key = Item.new()
				new_key.icon = nearest_item.get_node("Sprite2D").texture
				new_key.id = "null_item"
				new_key.name = nearest_item.id
				new_key.description = "N/A"
				GlobalData.player_inventory.add_item(new_key)
				nearest_item.queue_free()
			elif nearest_item is not Foragable:
				GlobalData.player_inventory.add_item(nearest_item.item)
				nearest_item.queue_free()
			$ItemPickupSound.play()

func _handle_run(delta, flip_h):
	$AnimatedSprite2D.play(current_run_anim)
	$AnimatedSprite2D.flip_h = flip_h
	current_state = State.RUN
	_play_running_sound()

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
		
func set_spawn_point():
	var spawn_points = get_tree().get_nodes_in_group("spawn_points")
	
	if spawn_points.size() > 0:
		var closest_spawn = spawn_points[0]
		var closest_distance = global_position.distance_squared_to(closest_spawn.global_position)
		
		for spawn in spawn_points:
			var distance = global_position.distance_squared_to(spawn.global_position)
			if distance < closest_distance:
				closest_spawn = spawn
				closest_distance = distance
		
		spawn_point = closest_spawn.global_position
	else:
		spawn_point = global_position

func respawn():
	set_spawn_point()  # Find the closest spawn point again
	global_position = spawn_point
	velocity = Vector2.ZERO
	current_state = State.IDLE
	$AnimatedSprite2D.play("idle")
	# Re-enable player input
	set_process_input(true)
	set_physics_process(true)

func handle_death():
	current_state = State.DEATH
	$AnimatedSprite2D.play("death")
	$DeathSound.play()
	set_process_input(false)
	set_physics_process(false)
	await $AnimatedSprite2D.animation_finished
	respawn()

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

func _play_running_sound():
	if not $RunningSound.is_playing():
		$RunningSound.play()

func _stop_running():
	if $AnimatedSprite2D.animation == current_run_anim:
		$AnimatedSprite2D.play(current_idle_anim)
		_stop_running_sound()

func _stop_running_sound():
	if $RunningSound.is_playing():
		$RunningSound.stop()
		
func _play_telekinesis_sound():
	if not $TelekinesisSound.is_playing():
		$TelekinesisSound.play()

func _stop_telekinesis_sound():
	if $TelekinesisSound.is_playing():
		$TelekinesisSound.stop()
		
func _play_climbing_sound():
	if not $ClimbingSound.playing:
		$ClimbingSound.play()

func _stop_climbing_sound():
	if $ClimbingSound.playing:
		$ClimbingSound.stop()
		
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
		_play_telekinesis_sound()

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
