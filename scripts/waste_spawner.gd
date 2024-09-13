extends Node2D

signal spawned_trash(new_trash)

var scrap_object = load("res://scenes/waste/scrap.tscn")
var bottle_object = load("res://scenes/waste/bottle.tscn")

var rng = RandomNumberGenerator.new()
var timer = 0
@export var min_x = -550
@export var max_x = 300
@export var default_y = -120
@onready var waste_container: Node2D = $".."
var spawn_timer = GameManager.spawn_rate

func _ready():
	GameManager.game_start.connect(_on_game_start)
	GameManager.storming.connect(_on_game_storming)
	GameManager.clear_weather.connect(_on_game_clear_weather)

func _process(delta):
	if timer + delta > spawn_timer:
		spawn_waste()
		timer = 0
	else:
		timer += delta

func spawn_waste():
	var random_obj = rng.randi_range(0, 1)
	var new_waste
	if random_obj == 1:
		new_waste = scrap_object.instantiate()
	else:
		new_waste = bottle_object.instantiate()
	
	var random_x = rng.randi_range(min_x, max_x)
	var new_position = global_position
	new_position.x = random_x
	new_position.y = default_y
	
	new_waste.global_position = new_position
	waste_container.add_child(new_waste)
	spawned_trash.emit(new_waste)

func _on_game_storming() -> void:
	spawn_timer = GameManager.storm_spawn_rate

func _on_game_clear_weather() -> void:
	spawn_timer = GameManager.spawn_rate

func _on_game_start() -> void:
	spawn_timer = GameManager.spawn_rate
