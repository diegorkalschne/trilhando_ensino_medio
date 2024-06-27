extends Node

var _player # instância do player de música
var _seek_sound

var _player_menu # Instância da música do menu

# Iniciar reprodução da música
func playMusic():
	if _player != null:
		if _player.playing:
			return
	
	if _player == null:
		_player = AudioStreamPlayer2D.new()
	
	var audio_stream = load("res://songs/music2.wav")
	
	_player.stream = audio_stream
	_player.volume_db = -8
	
	get_tree().root.add_child(_player)
	
	_player.play()
	

# Pausar a música
func pauseMusic():
	if _player != null:
		_seek_sound = _player.get_playback_position() # Obtém o tempo atual da música
		_player.stop()
	else:
		playMusic()

# Retomar a música
func resumeMusic():
	if _player != null:
		_player.play()
		_player.seek(_seek_sound) # Retoma a música onde foi "pausada"
	else:
		playMusic()

# Inicia a música usada no menu
func playMusicMenu():
	if _player_menu != null:
		if _player_menu.playing:
			return
	
	if _player_menu == null:
		_player_menu = AudioStreamPlayer2D.new()
	
	var audio_stream = load("res://songs/menu_music.mp3")
	
	_player_menu.stream = audio_stream
	_player_menu.volume_db = -2
	
	add_child(_player_menu)
	
	_player_menu.play()

# Para a música usada no menu
func stopMusicMenu():
	if _player_menu != null:
		_player_menu.stop()
