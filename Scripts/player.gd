extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const RUN_ROTATION = 0.00
const ROTATION_SPEED = 10.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")	

enum State {
	IDLE,
	RUN,
	JUMP,
	LAND,
	SLICE,
	THROW
}

var current_state = State.IDLE

func _ready():
	$AnimatedSprite2D.play("idle")
	$AnimatedSprite2D.animation_finished.connect(_on_landing_animation_finished)
	

func _physics_process(delta):
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
