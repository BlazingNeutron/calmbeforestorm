extends Node2D

var waste = load("res://scenes/waste.tscn")
var rng = RandomNumberGenerator.new()
@export var spawnTimer = 2
var timer = 0
@export var minX = -550
@export var maxX = 350
@export var defaultY = -400

func _ready():
	timer = 500

func _process(delta):
	if timer + delta > spawnTimer:
		spawnWaste()
		timer = 0
	else:
		timer += delta

func spawnWaste():
	var randomX = rng.randi_range(minX, maxX)
	var newPosition = global_position
	newPosition.x = randomX
	newPosition.y = defaultY
	var newWaste = waste.instantiate()
	newWaste.global_position = newPosition
	get_tree().root.add_child(newWaste)
