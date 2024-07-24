extends AudioStreamPlayer

#const bgm = preload("res://Audio/OST/Down the Hatch (Main Theme).mp3")

func _play_song(music: AudioStream, volume = 0.0):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
		
func play_song_chosen(song):
	_play_song(song)

func stop_current():
	stop()
	
