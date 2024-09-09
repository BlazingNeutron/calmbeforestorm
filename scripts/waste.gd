extends Node2D

signal landed(trash)
signal picked_up(trash)

@onready var pick_up_sound: AudioStreamPlayer = $PickUpSound

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
			get_picked_up()

func get_picked_up() -> void:
	pick_up_sound.play()
	self.hide()
	picked_up.emit(self)

func _on_pick_up_sound_finished() -> void:
	queue_free()
