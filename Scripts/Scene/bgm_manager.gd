extends AudioStreamPlayer

var volume = -80

func _play_song(music: AudioStream, volume: float):
	if stream == music:
		return
		
	stream = music
	volume_db = volume
	play()
		
func play_song_chosen(song):
	var nowplaying = AudioStreamPlayer.new()
	_play_song(song, volume)
	
func update_bgm_music_vol(newvolume):
	volume = newvolume
	
func get_volume():
	return volume
	
func stop_current():
	stop()
	
