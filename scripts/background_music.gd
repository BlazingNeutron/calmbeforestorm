extends Node

@onready var ocean_sounds_audio_player: AudioStreamPlayer = $OceanSoundsAudioPlayer
@onready var background_music_audio_player: AudioStreamPlayer = $BackgroundMusicAudioPlayer

var calm_music = "res://assets/audio/cottagecore-17463.mp3"
var storm_music = "res://assets/audio/big-storm-orchestral-8952.mp3"
var calm_background = "res://assets/audio/gentle-ocean-waves-birdsong-and-gull-7109.mp3"
var storm_background = "res://assets/audio/heavy-rain-splatty-on-stone-31947.mp3"

func _ready() -> void:
	GameManager.storm_warning.connect(_on_storm_warning)
	GameManager.game_over.connect(_on_storm_end)
	GameManager.clear_weather.connect(_on_storm_end)

func _on_storm_warning() -> void:
	change_music(storm_background, storm_music)

func _on_storm_end() -> void:
	change_music(calm_background, calm_music)

func change_music(ocean, music) -> void:
	var tween = create_tween()
	tween.tween_property(ocean_sounds_audio_player, "volume_db", 0, 1)
	tween.tween_property(background_music_audio_player, "volume_db", 0, 1)
	ocean_sounds_audio_player.stream = ResourceLoader.load(ocean)
	ocean_sounds_audio_player.play()
	background_music_audio_player.stream = ResourceLoader.load(music)
	background_music_audio_player.play()
	tween.tween_property(ocean_sounds_audio_player, "volume_db", 1, 1)
	tween.tween_property(background_music_audio_player, "volume_db", 1, 1)
