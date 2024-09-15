extends Sprite2D

@onready var save_me_sparkle: AudioStreamPlayer = $"../SaveMeSparkle"

var its_on = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.save_me.connect(_on_save_me)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if its_on:
		if not save_me_sparkle.playing:
			save_me_sparkle.play()
		position.x += 1200 * delta
	if position.x >= 2000:
		position.x = -1500
		its_on = false

func _on_save_me() -> void:
	its_on = true
