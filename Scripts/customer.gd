extends CharacterBody2D
class_name Customer

var wanted_potion : CraftRecipe

const speed = 100.0
var direction = 0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = direction * speed
	
	if velocity.x == 0:
		$AnimatedSprite2D.play("idle")
	elif velocity.x > 0:
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = true

	move_and_slide()
