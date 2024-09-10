extends Node2D

signal warning
signal storming
signal clear_weather

@onready var next_storm_timer: Timer = %NextStormTimer
@onready var storm_duration: Timer = $StormDuration

@export var time_to_next_storm : int = 1
@export var storm_duration_time : int = 30

func _ready() -> void:
	next_storm_timer.wait_time = time_to_next_storm
	storm_duration.wait_time = storm_duration_time
	next_storm_timer.start()

func _on_storm_timer_timeout() -> void:
	#print("Storm warning timer")
	warning.emit()
	next_storm_timer.stop()

func _on_hud_warning_completed() -> void:
	storming.emit()
	storm_duration.start()

func _on_storm_duration_timeout() -> void:
	clear_weather.emit()
	next_storm_timer.start()
