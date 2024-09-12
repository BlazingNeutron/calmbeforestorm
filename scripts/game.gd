extends Node2D

signal warning
signal storming
signal clear_weather
signal time_update(time, increment)

@onready var next_storm_timer: Timer = %NextStormTimer
@onready var storm_duration: Timer = $StormDuration

@export var time_increment : int = 15

var rng = RandomNumberGenerator.new()
var time_to_next_storm : int = 60
var time_of_day : int = 0
var paused = false

func _ready() -> void:
	rng.randomize()
	GameManager.game_start()
	clear_weather.connect(GameManager._on_storm_over)
	time_update.connect(GameManager._on_time_update)
	time_to_next_storm = rng.randi_range(GameManager.min_time_to_next_storm, GameManager.max_time_to_next_storm)
	next_storm_timer.wait_time = time_to_next_storm
	storm_duration.wait_time = GameManager.storm_duration_time
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

func _on_beach_border_body_entered(body: Node2D) -> void:
	#print("something's here")
	body.unassign()

func _on_time_of_day_timer_timeout() -> void:
	time_of_day += time_increment
	time_update.emit(time_of_day, time_increment)

func _on_beach_border_body_exited(body: Node2D) -> void:
	#print("something's leaving")
	body.unassign()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	#print("pausing")
	get_tree().paused = !get_tree().paused
	$hud/Settings.visible = !$hud/Settings.visible

func _on_settings_visibility_changed() -> void:
	#print("settings visibility changed")
	if not $hud/Settings.visible:
		get_tree().paused = false
