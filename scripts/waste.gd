extends Node2D

signal landed(trash)
signal picked_up(trash)

@onready var pick_up_sound: AudioStreamPlayer = $PickUpSound
@onready var sprite: Sprite2D = $Sprite2D
@onready var poof: CPUParticles2D = $PoofAnimationParticles

@export var SPEED : int = 100
var has_landed : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if position.y < 200:
		position.y += delta * SPEED
	elif has_landed == false and position.y > 200:
		has_landed = true
		landed.emit(self)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('action'):
			viewport.get_viewport().set_input_as_handled()
			get_picked_up(true)

func get_picked_up(play_sound : bool = false) -> void:
	sprite.hide()
	poof.emitting = true
	poof.restart()
	if play_sound:
		pick_up_sound.play()
	
	picked_up.emit(self)

func _on_pick_up_sound_finished() -> void:
	queue_free()

func move_to_beach_frame() -> void:
	sprite.frame = 0
