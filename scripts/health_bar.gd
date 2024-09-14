extends ProgressBar

func _ready() -> void:
	GameManager.game_start.connect(_on_game_start)
	GameManager.health_changed.connect(update_health_bar)
	update_health_bar()

func _on_game_start() -> void:
	update_health_bar()

func update_health_bar():
	#print("update_health_bar ", GameManager.health)
	value = GameManager.health
	var styleBox = get_theme_stylebox("fill")
	if value > 70.0:
		styleBox.set("bg_color", Color(0.0, 1.0, 0.0))
	elif value > 30.0:
		styleBox.set("bg_color", Color(1.0, 1.0, 0.0))
	else:
		styleBox.set("bg_color", Color(1.0, 0.0, 0.0))
