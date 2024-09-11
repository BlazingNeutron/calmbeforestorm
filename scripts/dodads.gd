extends Node2D

@onready var dodad_timer: Timer = $DodadTimer
@onready var crab_dodad: AnimatedSprite2D = %CrabDodad
@onready var shark_dodad: AnimatedSprite2D = %SharkDodad

@export var dodad_list = [ 
	"crab", 
	"shark"
]
@export var dodads = {
	"crab": { "beach": true, "sprite": "%CrabDodad", "moving": false, "scaling": false, "scale": 3 },
	"shark": { "beach": false, "sprite": "%SharkDodad", "moving": true, "scaling": true }
}

@export var timer : int = 25
@export var timer_max : int = 1
@export var timer_min : int = 1

var rng = RandomNumberGenerator.new()
var current_dodad = null
var moving_dodad = false
var scaled_dodad = false

func _ready() -> void:
	rng.randomize()
	start_a_dodad_timer()

func _process(delta: float) -> void:
	if moving_dodad:
		current_dodad.position.x += (40 * delta)
	if scaled_dodad:
		calculate_scale(position.y)

func calculate_scale(y : float) -> void:
	var scale_value = (0.002 * y) + 0.5
	current_dodad.scale.x = scale_value
	current_dodad.scale.y = scale_value

func start_a_dodad_timer() -> void:
	timer = rng.randi_range(timer_min, timer_max)
	dodad_timer.wait_time = timer
	dodad_timer.start()

func _on_dodad_timer_timeout() -> void:
	var dodad_index = rng.randi_range(0, dodad_list.size() - 1)
	var dodad_item = dodads.get(dodad_list[dodad_index])
	var sprite = get_node(dodad_item.sprite)
	var x
	var y
	if dodad_item.beach:
		x = rng.randi_range(-530, 500)
		y = rng.randi_range(200, 290)
	elif not dodad_item.beach:
		x = rng.randi_range(-530, 480)
		y = rng.randi_range(-200, 180)
	current_dodad = sprite
	if dodad_item.moving:
		moving_dodad = dodad_item.moving
	scaled_dodad = dodad_item.scaling
	if not dodad_item.scaling:
		sprite.scale.x = dodad_item.scale
		sprite.scale.y = dodad_item.scale
	sprite.position.x = x
	sprite.position.y = y
	sprite.show()
	sprite.play()

func _on_shark_dodad_animation_finished() -> void:
	moving_dodad = null
	start_a_dodad_timer()

func _on_crab_dodad_animation_finished() -> void:
	moving_dodad = null
	start_a_dodad_timer()
