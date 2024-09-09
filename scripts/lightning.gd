extends CanvasLayer

@onready var flash_sprite: Sprite2D = $flash_sprite

func lightning_strike() -> void:
	print("lightning")
	var tween = get_tree().create_tween()
	tween.tween_property(flash_sprite, "modulate:a", 0.6, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).finished
	tween.tween_property(flash_sprite, "modulate:a", 0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN).finished
	
