extends ProgressBar

func _ready() -> void:
	GameManager.transgression_changed.connect(update_health_bar)
	update_health_bar()

func update_health_bar():
	value = GameManager.transgressions
	var styleBox = get_theme_stylebox("fill")
	if value > 7:
		styleBox.set("bg_color", Color(0.0, 1.0, 0.0))
	elif value > 3:
		styleBox.set("bg_color", Color(1.0, 1.0, 0.0))
	else:
		styleBox.set("bg_color", Color(1.0, 0.0, 0.0))
