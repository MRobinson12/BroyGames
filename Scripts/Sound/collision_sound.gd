extends AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready(from_position=0.0):
	randomize()
	pitch_scale = randf_range(0.8 , 0.9) 
	
	play(from_position)
