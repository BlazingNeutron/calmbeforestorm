extends Node

signal game_start
signal game_over
signal level_up

signal money_changed
signal purchase_store_item(store_item_name)
signal health_changed
signal time_update(increment)

signal storm_warning
signal storming
signal clear_weather

signal save_me

@onready var next_storm_timer: Timer = %NextStormTimer
@onready var storm_duration: Timer = $StormDuration
@onready var time_of_day_timer: Timer = $TimeOfDayTimer

@export var time_increment : int = 15
@export var max_health : float = 100.0
@export var starting_money : int = 0
@export var store_items = {
	"staff" : { "cost": 50, "upgrade": false, "scene": preload("res://scenes/picker_uppers/staff.tscn") },
	"boat" : { "cost": 250, "upgrade": false, "scene": preload("res://scenes/picker_uppers/boat.tscn") },
	"regen" : { "cost": 200, "upgrade": true },
	"walking" : { "cost": 150, "upgrade": true },
	"boating" : { "cost": 300, "upgrade": true },
	"save_me" : { "cost": 500, "upgrade": true }
}
@export var init_max_time_to_next_storm : int = 35
@export var init_min_time_to_next_storm : int = 20
@export var initial_storm_duration_time : int = 15
@export var initial_spawn_rate : float = 2
@export var initial_storm_spawn_rate : float = 0.4
@export var trash_credits : int = 5
@export var initial_health_regen : float = 5.0
@export var initial_walking_bonus_speed : int = 0
@export var initial_boat_bonus_speed : int = 0

var max_time_to_next_storm : int = init_max_time_to_next_storm
var min_time_to_next_storm : int = init_min_time_to_next_storm
var storm_spawn_rate : float = initial_storm_spawn_rate
var storm_duration_time : int = 15
var spawn_rate : float = initial_spawn_rate
var rng = RandomNumberGenerator.new()
var time_to_next_storm : int = 60
var time_of_day : int = 0
var money : int = 0
var health : float = 100
var score : int = 0
var is_game_over : bool = false
var high_scores : Scores = null
var health_regen : float = initial_health_regen
var trash_count : int = 0
var trash_damage_per : float = 2.5
var bonus_walking_speed : int = initial_walking_bonus_speed
var bonus_boat_speed : int = initial_boat_bonus_speed
var level = 0

func _ready() -> void:
	rng.randomize()
	high_scores = Scores.load()
	get_window().title = "Beach Clean Up Crew"

func credit_account() -> void:
	if not is_game_over:
		money += GameManager.trash_credits
		money_changed.emit()

func debit_account(item_name : String) -> void:
	money -= GameManager.store_items.get(item_name).cost
	money_changed.emit()
	if item_name == "regen":
		health_regen += 0.5
	elif item_name == "walking":
		bonus_walking_speed += 6
	elif item_name == "boating":
		bonus_boat_speed += 7
	elif item_name == "save_me":
		trash_count = 0
		save_me.emit()
		storm_duration.stop()
		clear_weather.emit()
	elif not GameManager.store_items.get(item_name).upgrade:
		purchase_store_item.emit(item_name)

func update_health() -> void:
	#print("updating health")
	health = health - (trash_count * trash_damage_per) + health_regen
	if health > max_health:
		health = max_health
	if health <= 0 and not is_game_over:
		_game_over()
	health_changed.emit()

func start_game() -> void:
	money = starting_money
	health = max_health
	score = 0
	level = 0
	time_of_day = 0
	trash_count = 0
	bonus_walking_speed = initial_walking_bonus_speed
	bonus_boat_speed = initial_boat_bonus_speed
	health_regen = initial_health_regen
	is_game_over = false
	spawn_rate = initial_spawn_rate
	storm_spawn_rate = initial_storm_spawn_rate
	storm_duration_time = initial_storm_duration_time
	max_time_to_next_storm = init_max_time_to_next_storm
	min_time_to_next_storm = init_min_time_to_next_storm
	time_to_next_storm = rng.randi_range(min_time_to_next_storm, max_time_to_next_storm)
	next_storm_timer.wait_time = time_to_next_storm
	storm_duration.wait_time = storm_duration_time
	
	next_storm_timer.start()
	time_of_day_timer.start()
	storm_duration.stop()
	
	game_start.emit()
	money_changed.emit()
	health_changed.emit()

func stop_game(forced: bool) -> void:
	if forced:
		clear_weather.emit()
	money_changed.emit()
	health = 0
	health_changed.emit()
	score += money
	is_game_over = true
	next_storm_timer.stop()
	time_of_day_timer.stop()
	storm_duration.stop()

func _game_over() -> void:
	stop_game(false)
	# save highscore
	high_scores.add(score)
	high_scores.save()
	game_over.emit()

func _on_level_up():
	#print("leveling up")
	level += 1
	spawn_rate = spawn_rate/1.2
	storm_spawn_rate = storm_spawn_rate/1.2
	storm_duration_time += 5
	if max_time_to_next_storm > 2:
		max_time_to_next_storm -= 2
	if min_time_to_next_storm > 2:
		min_time_to_next_storm -= 2
	level_up.emit()

func _on_storm_duration_timeout() -> void:
	clear_weather.emit()
	_on_level_up()
	next_storm_timer.start()

func _on_time_of_day_timer_timeout() -> void:
	time_of_day += time_increment
	if not is_game_over:
		score += time_increment
	time_update.emit(time_increment)
	update_health()

func _on_next_storm_timer_timeout() -> void:
	#print("Next storm warning start")
	storm_warning.emit()
	next_storm_timer.stop()

func _on_warning_complete() -> void:
	storming.emit()
	storm_duration.start()

func _on_increase_trash_count() -> void:
	trash_count += 1

func _on_decrease_trash_count() -> void:
	trash_count -= 1
