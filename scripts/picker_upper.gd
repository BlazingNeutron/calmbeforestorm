extends Node2D

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var pickup_timer: Timer = $PickupTimer

@export var speed : int = 70
@export var is_beach_bound : bool = true
@export var is_water_bound : bool = false
@export var capacity = 0
@export var pickup_time = 3

var trash : Node2D = null
var assigned : bool = false

func _ready() -> void:
	pickup_timer.wait_time = pickup_time
	start_sound()

func _process(delta: float) -> void:
	if trash != null and pickup_timer.is_stopped():
		var distance = position.distance_to(trash.position)
		if trash.position.x < position.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		if is_water_bound:
			position = position.move_toward(trash.position, delta * speed * (0.002 * position.y) + 0.9)
		else:
			position = position.move_toward(trash.position, delta * speed)
		if distance < 10:
			#print("I picked one up")
			sprite.play("pickup")
			#print("pickup animation is playing")
			pickup_timer.start()
			#print("pickup timer started")
	if is_water_bound:
		calculate_scale(position.y)

func calculate_scale(y : float) -> void:
	var scale_value = (0.002 * y) + 0.9
	scale.x = scale_value
	scale.y = scale_value

func spawn_position() -> Vector2:
	assert(false, "Please override `spawn_position()` in the derived script.")
	return Vector2.ZERO

func assign_trash(new_trash : Node2D) -> void:
	#print("Assigning trash")
	trash = new_trash
	sprite.play("move")
	#print("playing move")
	assigned = true

func unassign() -> void:
	assigned = false
	if trash != null:
		trash.claimed = false
	sprite.play("default")

func start_sound() -> void:
	audio_stream_player.play()

func _on_pickup_timer_timeout() -> void:
	#print("done picking up")
	if trash != null:
		#print("trash is deleting")
		sprite.play("default")
		#print("default playing")
		trash.get_picked_up()
	assigned = false
