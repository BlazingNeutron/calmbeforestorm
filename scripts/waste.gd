extends Node2D

signal landed(trash)
signal picked_up(trash)

@export var SPEED : int = 100
var has_landed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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
	picked_up.emit(self)
	queue_free()
