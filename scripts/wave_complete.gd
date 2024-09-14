extends Control

@onready var wave_complete_label: Label = $WaveCompleteLabel
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.level_up.connect(_on_level_up)

func _on_level_up() -> void:
	#print("wave complete")
	wave_complete_label.text = "Wave " + str(GameManager.level) + " Complete!"
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	timer.start()

func _on_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
