extends RigidBody2D

var sound_factor_x = 3
var sound_factor_y = 0.005
var pitch_scale = 0

func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if abs(self.linear_velocity.x)>sound_factor_x or abs(self.linear_velocity.y)>sound_factor_y:
		pitch_scale = randf_range(0.4 , 0.7)
		$CollisionSound.set_pitch_scale(pitch_scale)
		$CollisionSound.play()
