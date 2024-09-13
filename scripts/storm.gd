extends CanvasLayer

@onready var flash_sprite: Sprite2D = $flash_sprite
@onready var thunder: AudioStreamPlayer = $thunder
@onready var pause_between_lightning: Timer = $PauseBetweenLightning
@onready var storm_dimming: ColorRect = $StormDimming

var storming : bool = false
var thunder_still_rolls : bool = false

func _ready() -> void:
	GameManager.storming.connect(start)
	GameManager.clear_weather.connect(stop)

func _process(_delta: float) -> void:
	if storming and not thunder_still_rolls:
		lightning_strike()

func lightning_strike() -> void:
	#print("lightning")
	pause_between_lightning.start()
	thunder_still_rolls = true
	var tween = get_tree().create_tween()
	tween.tween_property(flash_sprite, "modulate:a", 0.4, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_property(flash_sprite, "modulate:a", 0, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	#play noise
	thunder.play()

func start() -> void:
	storming = true
	storm_dimming.show()

func stop() -> void:
	storming = false
	storm_dimming.hide()

func _on_pause_between_lightning_timeout() -> void:
	thunder_still_rolls = false
