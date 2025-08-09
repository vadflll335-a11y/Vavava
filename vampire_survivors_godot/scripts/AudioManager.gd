extends Node

# Audio Manager для управления звуками в игре
# Singleton - добавьте в AutoLoad в project settings

var sound_effects = {}
var music_player: AudioStreamPlayer
var master_volume := 1.0
var sfx_volume := 1.0
var music_volume := 1.0

func _ready():
	# Create music player
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.bus = "Music"

func play_sound(sound_name: String, position: Vector2 = Vector2.ZERO):
	# Play sound effect at position (for 2D spatial audio)
	if sound_name in sound_effects:
		var audio_player = AudioStreamPlayer2D.new()
		get_tree().current_scene.add_child(audio_player)
		audio_player.stream = sound_effects[sound_name]
		audio_player.global_position = position
		audio_player.play()
		
		# Auto-remove after playing
		audio_player.finished.connect(audio_player.queue_free)

func play_music(music_stream: AudioStream, fade_in: bool = false):
	music_player.stream = music_stream
	if fade_in:
		music_player.volume_db = -80
		music_player.play()
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", 0, 1.0)
	else:
		music_player.play()

func stop_music(fade_out: bool = false):
	if fade_out:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80, 1.0)
		tween.tween_callback(music_player.stop)
	else:
		music_player.stop()

func set_master_volume(volume: float):
	master_volume = clamp(volume, 0.0, 1.0)
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))

func set_sfx_volume(volume: float):
	sfx_volume = clamp(volume, 0.0, 1.0)
	AudioServer.set_bus_volume_db(1, linear_to_db(sfx_volume))

func set_music_volume(volume: float):
	music_volume = clamp(volume, 0.0, 1.0)
	AudioServer.set_bus_volume_db(2, linear_to_db(music_volume))