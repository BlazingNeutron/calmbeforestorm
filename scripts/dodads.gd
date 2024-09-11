extends Node2D

@onready var dodad_timer: Timer = $DodadTimer
@onready var crab_dodad: AnimatedSprite2D = %CrabDodad

@export var dodad_list = [ "crab" ]
@export var dodads = {
	"crab": { "beach": true, "sprite": "%CrabDodad" }
}

@export var timer : int = 25
@export var timer_max : int = 25
@export var timer_min : int = 7

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	start_a_dodad_timer()

func start_a_dodad_timer() -> void:
	timer = rng.randi_range(timer_min, timer_max)
	dodad_timer.wait_time = timer
	dodad_timer.start()

func _on_dodad_timer_timeout() -> void:
	var dodad_index = rng.randi_range(0, dodad_list.size() - 1)
	var dodad_item = dodads.get(dodad_list[dodad_index])
	var sprite = get_node(dodad_item.sprite)
	if dodad_item.beach:
		var x = rng.randi_range(-50, 420)
		var y = rng.randi_range(230, 300)
		sprite.position.x = x
		sprite.position.y = x
		sprite.show()
		sprite.play()
	start_a_dodad_timer
