extends CanvasLayer

@onready var store: Control = $store
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("RESET")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("store") and Engine.time_scale > 0:
		open_store()
	elif Input.is_action_just_pressed("store") and Engine.time_scale == 0:
		close_store()

func open_store():
	print("open store")
	animation_player.play("blur")
	store.show()

func _on_open_store_pressed() -> void:
	if Engine.time_scale == 1:
		open_store()

func close_store():
	print("close store")
	store.hide()
	animation_player.play_backwards("blur")

func _on_store_hide() -> void:
	close_store()
