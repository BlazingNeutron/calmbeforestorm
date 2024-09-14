extends CanvasLayer

@onready var flash_sprite: Sprite2D = $flash_sprite
@onready var thunder: AudioStreamPlayer = $thunder
@onready var pause_between_lightning: Timer = $PauseBetweenLightning
@onready var storm_dimming: ColorRect = $StormDimming
@onready var left_clouds: Sprite2D = $LeftClouds
@onready var right_clouds: Sprite2D = $RightClouds
@onready var clouds_movement_timer: Timer = $CloudsMovementTimer
@onready var rain_particles: CPUParticles2D = $RainParticles

var storming : bool = false
var thunder_still_rolls : bool = false
var clouds_on_the_move : bool = false

func _ready() -> void:
	GameManager.storming.connect(start)
	GameManager.clear_weather.connect(stop)

func _process(delta: float) -> void:
	if storming and not thunder_still_rolls:
		lightning_strike()
	if clouds_on_the_move:
		var direction = 1
		if not storming:
			direction = -1
		left_clouds.position.x += direction * 300 * delta
		right_clouds.position.x -= direction * 300 * delta

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
	rain_particles.restart()
	rain_particles.emitting = true
	storming = true
	clouds_on_the_move = true
	clouds_movement_timer.start()
	var tween = get_tree().create_tween()
	tween.tween_property(storm_dimming, "modulate:a", 0.4, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func stop() -> void:
	rain_particles.emitting = false
	storming = false
	clouds_on_the_move = true
	clouds_movement_timer.start()
	var tween = get_tree().create_tween()
	tween.tween_property(storm_dimming, "modulate:a", 0.0, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _on_pause_between_lightning_timeout() -> void:
	thunder_still_rolls = false

func _on_clouds_movement_timer_timeout() -> void:
	clouds_on_the_move = false
