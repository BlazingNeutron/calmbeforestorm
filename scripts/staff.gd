extends "res://scripts/picker_upper.gd"

var rng = RandomNumberGenerator.new()
#Centered around Vector2(0, 250)
@export var min_x = -550
@export var max_x = 300
@export var default_y = 250

func _ready() -> void:
	speed = 60
	is_beach_bound = true
	is_water_bound = false
	pickup_time = 3
	super._ready()

func spawn_position() -> Vector2:
	var random_x = rng.randi_range(min_x, max_x)
	return Vector2(random_x, default_y)
