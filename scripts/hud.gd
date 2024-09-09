extends CanvasLayer

@onready var lightning: CanvasLayer = $lightning
@onready var money_label: RichTextLabel = %Money
@onready var picker_upper_manager: Node2D = %PickerUpperManager
@onready var storm_warning_icon: Node = $StormWarning

@export var starting_money : int = 100
var money : int = 0

func _ready() -> void:
	picker_upper_manager.update_money.connect(_on_update_money)
	money = starting_money

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("test_lightning"):
		lightning.lightning_strike()

func _on_update_money() -> void:
	money += 5
	money_label.text = "$" + str(money)

func storm_warning() -> void:
	storm_warning_icon.start_storm_warning()
