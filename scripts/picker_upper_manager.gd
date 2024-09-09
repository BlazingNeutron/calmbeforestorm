extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_waste_spawner_spawned_trash(new_trash) -> void:
	print("spawned trash ", new_trash.position.x)
	new_trash.landed.connect(_on_trash_landed)

func _on_trash_landed(position) -> void:
	print("Trash landed", position)
