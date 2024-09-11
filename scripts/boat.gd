extends "res://scripts/picker_upper.gd"

var rng = RandomNumberGenerator.new()
#Centered around Vector2(0, 0)
@export var min_x = -550
@export var max_x = 300
@export var default_y = 0

func _ready() -> void:
	speed = 90
	is_beach_bound = false
	is_water_bound = true
	pickup_time = 1
	super._ready()

func spawn_position() -> Vector2:
	var random_x = rng.randi_range(min_x, max_x)
	return Vector2(random_x, default_y)
