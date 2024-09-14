extends Node

var rng = RandomNumberGenerator.new()
#Centered around Vector2(0, 250)
@export var min_x = -550
@export var max_x = 550
@export var default_y = 250

func spawn_waste():
	var random_obj = rng.randi_range(0, 1)
	var new_position = Vector2(0, 250)
	var random_x = rng.randi_range(min_x, max_x)
	new_position.x = random_x
	new_position.y = default_y
	return new_position
