extends Node2D

@onready var dodad_timer: Timer = $DodadTimer
@onready var crab_dodad: AnimatedSprite2D = %CrabDodad

@export var dodad_list = [ "crab", "shark" ]
@export var dodads = {
	"crab": { "beach": true, "sprite": "%CrabDodad", "moving": false },
	"shark": { "beach": false, "sprite": "%SharkDodad", "moving": true }
}

@export var timer : int = 25
@export var timer_max : int = 30
@export var timer_min : int = 7

var rng = RandomNumberGenerator.new()
var moving_dodad = null

func _ready() -> void:
	start_a_dodad_timer()

func _process(delta: float) -> void:
	if moving_dodad != null:
		moving_dodad.position.x += (40 * delta)

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
		x = rng.randi_range(-50, 420)
		y = rng.randi_range(230, 300)
	elif not dodad_item.beach:
		x = rng.randi_range(-500, 420)
		y = rng.randi_range(-200, 180)
	if dodad_item.moving:
		moving_dodad = sprite
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
