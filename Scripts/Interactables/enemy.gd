extends CharacterBody2D
class_name Enemy

@export var speed = 75
var direction = -1  # 1 for right, -1 for left

func _ready():
	add_to_group("hazards")

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = direction * speed
	
	# Update animation based on movement
	if velocity.x == 0:
		$AnimatedSprite2D.play("idle")
	elif velocity.x > 0:
		$AnimatedSprite2D.play("move")
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.play("move")
		$AnimatedSprite2D.flip_h = true
	
	# Move and check for collisions
	move_and_slide()
	
	# If we hit a wall, turn around
	if is_on_wall():
		direction *= -1

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D and body.has_method("handle_death"):
		body.handle_death()
