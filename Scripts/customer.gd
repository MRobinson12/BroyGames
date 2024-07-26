extends CharacterBody2D
class_name Customer

var wanted_potion : CraftRecipe

const speed = 100.0
var direction = 0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


	velocity.x = direction * speed

	move_and_slide()
