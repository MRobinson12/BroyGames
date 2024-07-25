extends Node

const bgm = preload("res://Audio/OST/Secrets Behind the Caverns (Calm Cavern).mp3")

# Called when the node enters the scene tree for the first time.
func _ready():
	BgmManager.play_song_chosen(bgm)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
