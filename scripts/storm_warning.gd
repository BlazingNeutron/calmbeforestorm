extends Node

@onready var storm_warning_icon: TextureRect = $StormWarningIcon
@onready var storm_warning_sound: AudioStreamPlayer = $StormWarningSound

@export var replays : int = 2
var replay_count : int = 0

func start_storm_warning() -> void:
	var tween = create_tween()
	storm_warning_sound.play()
	tween.tween_property(storm_warning_icon, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(storm_warning_icon, "modulate:a", 0.3, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(storm_warning_icon, "modulate:a", 1, 1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(storm_warning_icon, "modulate:a", 0.3, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(storm_warning_icon, "modulate:a", 1, 1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(storm_warning_icon, "modulate:a", 0, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_storm_warning_sound_finished() -> void:
	if replay_count < replays:
		storm_warning_sound.play()
		replay_count += 1
