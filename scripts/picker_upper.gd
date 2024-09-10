extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var speed : int = 70
@export var is_beach_bound : bool = true
@export var capacity = 0

var trash : Node2D = null
var assigned : bool = false

func _process(delta: float) -> void:
	if trash != null:
		var distance = position.distance_to(trash.position)
		position = position.move_toward(trash.position, delta * speed)
		if distance < 10:
			#print("I picked one up")
			trash.get_picked_up()
			assigned = false

func spawn_position() -> Vector2:
	#assert(false, "Please override `spawn_position()` in the derived script.")
	return Vector2(0, 250)

func assign_trash(new_trash : Node2D) -> void:
	trash = new_trash
	assigned = true

func start_sound(count : int) -> void:
	if count <= 1:
		audio_stream_player.play()
