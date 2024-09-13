extends Node2D

@onready var settings: Control = $hud/Settings
@onready var storm_warning: CanvasLayer = $hud/StormWarning
@onready var storm: CanvasLayer = $hud/Storm
@onready var game_over_screen: Control = $hud/GameOverScreen

func _ready() -> void:
	GameManager.storm_warning.connect(_on_storm_warning)
	GameManager.storming.connect(_on_storm_start)
	GameManager.clear_weather.connect(_on_storm_stop)
	GameManager.game_over.connect(_on_game_over)

func _on_beach_border_body_entered(body: Node2D) -> void:
	#print("something's here")
	body.unassign()

func _on_beach_border_body_exited(body: Node2D) -> void:
	#print("something's leaving")
	body.unassign()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	#print("pausing")
	get_tree().paused = !get_tree().paused
	settings.visible = !settings.visible

func _on_settings_visibility_changed() -> void:
	#print("settings visibility changed")
	if not settings.visible:
		get_tree().paused = false

func _on_storm_warning() -> void:
	storm_warning.show()

func _on_storm_warning_warning_complete() -> void:
	storm_warning.hide()

func _on_storm_start() -> void:
	storm.show()

func _on_storm_stop() -> void:
	storm.hide()

func _on_game_over() -> void:
	game_over_screen.show()
