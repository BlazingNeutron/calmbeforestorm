extends ParallaxBackground

@onready var cloud_layer: ParallaxLayer = $CloudLayer

func _process(delta: float) -> void:
	scroll_base_offset += Vector2(-96, 0) * delta
