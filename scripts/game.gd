extends Node2D

@onready var hud: CanvasLayer = %hud
@onready var storm_timer: Timer = %StormTimer
@onready var waste_spawner: Node = %WasteSpawner

func _ready() -> void:
	storm_timer.start()

func _on_storm_timer_timeout() -> void:
	#print("Storm warning timer")
	hud.storm_warning()
	storm_timer.stop()
	waste_spawner.start_storm()
