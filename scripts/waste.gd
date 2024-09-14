extends Node2D

signal landed(trash)
signal picked_up(trash)

@onready var pick_up_sound: AudioStreamPlayer = $PickUpSound
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var poof: CPUParticles2D = $PoofAnimationParticles
@onready var coin_particles: CPUParticles2D = $CoinParticles

@export var SPEED : int = 20
var has_landed : bool = false
var claimed : bool = false
var picker_upper : Node2D = null
var picking_up : bool = false

@export var frequency = 3
@export var amplitude = 0.5
var time = 0
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y < 230:
		time += delta
		var movement = cos(time*frequency)*amplitude
		position.y += (SPEED * delta) + movement
	elif has_landed == false and position.y > 200:
		has_landed = true
		move_to_beach_frame()
		landed.emit(self)
	calculate_scale(position.y)
	if not visible:
		show()

func calculate_scale(y : float) -> void:
	var scale_value = (0.004 * y) + 0.8
	#print("scaling ", scale_value)
	sprite.scale.x = scale_value
	sprite.scale.y = scale_value

func _on_area_2d_input_event(viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('action'):
			viewport.get_viewport().set_input_as_handled()
			if not picking_up:
				picking_up = true
				get_picked_up(true)

func get_picked_up(play_sound : bool = false) -> void:
	#print("trash got picked up")
	sprite.hide()
	poof.emitting = true
	poof.restart()
	coin_particles.restart()
	coin_particles.emitting = true
	if play_sound:
		pick_up_sound.play()
	else:
		clear_trash()

func start_pickup() -> void:
	sprite.hide()
	$Area2D.input_pickable = false

func _on_pick_up_sound_finished() -> void:
	clear_trash()

func clear_trash(clear_with_pick_up : bool = true):
	if clear_with_pick_up:
		picked_up.emit(self)
	queue_free()

func move_to_beach_frame() -> void:
	sprite.play("landed")

func _on_coin_particles_finished() -> void:
	coin_particles.hide()
