extends Node2D

signal spawned_trash(new_trash)

var waste_object = load("res://scenes/waste.tscn")
var rng = RandomNumberGenerator.new()
@export var spawn_timer = 2
var timer = 0
@export var min_x = -550
@export var max_x = 350
@export var default_y = -400
@onready var waste_container: Node2D = $".."

func _ready():
	timer = 500

func _process(delta):
	if timer + delta > spawn_timer:
		spawn_waste()
		timer = 0
	else:
		timer += delta

func spawn_waste():
	var random_x = rng.randi_range(min_x, max_x)
	var new_position = global_position
	new_position.x = random_x
	new_position.y = default_y
	var new_waste = waste_object.instantiate()
	new_waste.global_position = new_position
	waste_container.add_child(new_waste)
	spawned_trash.emit(new_waste)
