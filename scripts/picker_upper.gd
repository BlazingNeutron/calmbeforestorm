extends Node2D

signal adopted(picker_upper)

@onready var picker_upper_manager: Node2D = $"../PickerUpperManager"

@export var speed : int = 120
@export var is_beach_bound : bool = true
# @export var capacity = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.adopted.connect(picker_upper_manager._on_picker_upper_adopted)
	adopted.emit(self)
