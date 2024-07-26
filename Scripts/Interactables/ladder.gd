extends Area2D

func _ready():
	body_entered.connect(_on_Ladder_body_entered)
	body_exited.connect(_on_Ladder_body_exited)

func _on_Ladder_body_entered(body):
	if body.has_method("_on_ladder_area_entered"):
		body._on_ladder_area_entered(self)

func _on_Ladder_body_exited(body):
	if body.has_method("_on_ladder_area_exited"):
		body._on_ladder_area_exited(self)
