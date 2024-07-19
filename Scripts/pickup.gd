extends Area2D

@export var item : Item

func _on_body_entered(body: Node2D) -> void:
	print("Test")
	if body.has_method("pickup_item"):
		body.pickup_item(item)
	queue_free()
