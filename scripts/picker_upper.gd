extends Node2D

@export var speed : int = 120
@export var is_beach_bound : bool = true
@export var capacity = 0

func spawn_position() -> Vector2:
	#assert(false, "Please override `spawn_position()` in the derived script.")
	return Vector2(0, 250)
