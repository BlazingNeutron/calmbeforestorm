extends Node2D

@onready var dodad_timer: Timer = $DodadTimer

@export var dodad_list = [ 
	"crab", 
	"shark",
	"fish"
]
@export var dodads = {
	"crab": { "beach": true, "sprite": "%CrabDodad", "moving": false, "scaling": false, "scale": 3 },
	"shark": { "beach": false, "sprite": "%SharkDodad", "moving": true, "scaling": true, "direction": "x" },
	"fish": { "beach": false, "sprite": "%FishDodad", "moving": false, "scaling": true },
	"wave": { "beach": false, "sprite": "%WaveDodad", "moving": true, "scaling": true, "direction": "y" },
}

@export var timer : int = 25
@export var timer_max : int = 25
@export var timer_min : int = 7

var rng = RandomNumberGenerator.new()
var current_dodad = null
var moving_direction = null
var scaled_dodad = false
var active_wave_dodad = null

func _ready() -> void:
	rng.randomize()
	start_a_dodad_timer()

func _process(delta: float) -> void:
	if active_wave_dodad != null:
		active_wave_dodad.position.y += (20 * delta)
		calculate_scale(active_wave_dodad, position.y)
	if current_dodad != null:
		if moving_direction == "x":
			current_dodad.position.x += (40 * delta)
		if scaled_dodad:
			calculate_scale(current_dodad, position.y)

func calculate_scale(dodad, y : float) -> void:
	var scale_value = (0.002 * y) + 0.9
	dodad.scale.x = scale_value
	dodad.scale.y = scale_value

func start_a_dodad_timer() -> void:
	timer = rng.randi_range(timer_min, timer_max)
	dodad_timer.wait_time = timer
	dodad_timer.start()

func _on_dodad_timer_timeout() -> void:
	var dodad_index = rng.randi_range(0, dodad_list.size() - 1)
	start_dodad(dodad_list[dodad_index])

func start_dodad(dodad_name : String) -> void:
	moving_direction = ""
	scaled_dodad = false
	current_dodad = null
	var dodad_item = dodads.get(dodad_name)
	var sprite = get_node(dodad_item.sprite)
	var x
	var y
	if dodad_item.beach:
		x = rng.randi_range(-530, 500)
		y = rng.randi_range(200, 290)
	elif not dodad_item.beach:
		x = rng.randi_range(-530, 480)
		y = rng.randi_range(-90, 180)
	if dodad_name != "wave":
		current_dodad = sprite
		if dodad_item.moving:
			moving_direction = dodad_item.direction
		scaled_dodad = dodad_item.scaling
	if dodad_name == "wave":
		active_wave_dodad = sprite
	if not dodad_item.scaling:
		sprite.scale.x = dodad_item.scale
		sprite.scale.y = dodad_item.scale
	sprite.position.x = x
	sprite.position.y = y
	sprite.show()
	sprite.play()

func _on_shark_dodad_animation_finished() -> void:
	start_a_dodad_timer()

func _on_crab_dodad_animation_finished() -> void:
	start_a_dodad_timer()

func _on_fish_dodad_animation_finished() -> void:
	start_a_dodad_timer()

func _on_wave_dodad_animation_finished() -> void:
	active_wave_dodad = null

func _on_wave_timer_timeout() -> void:
	#print("starting wave")
	start_dodad("wave")
