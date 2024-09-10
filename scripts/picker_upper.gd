extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var pickup_timer: Timer = $PickupTimer

@export var speed : int = 70
@export var is_beach_bound : bool = true
@export var capacity = 0
@export var pickup_time = 3

var trash : Node2D = null
var assigned : bool = false

func _ready() -> void:
	pickup_timer.wait_time = pickup_time

func _process(delta: float) -> void:
	if trash != null and pickup_timer.is_stopped():
		var distance = position.distance_to(trash.position)
		if trash.position.x < position.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		position = position.move_toward(trash.position, delta * speed)
		if distance < 10:
			#print("I picked one up")
			sprite.play("pickup")
			pickup_timer.start()

func spawn_position() -> Vector2:
	#assert(false, "Please override `spawn_position()` in the derived script.")
	return Vector2(0, 250)

func assign_trash(new_trash : Node2D) -> void:
	trash = new_trash
	sprite.play("move")
	assigned = true

func start_sound(count : int) -> void:
	if count <= 1:
		audio_stream_player.play()

func _on_pickup_timer_timeout() -> void:
	#print("done picking up")
	if trash != null:
		sprite.play("default")
		trash.get_picked_up()
	assigned = false
	
