extends Node

signal _on_money_changed(money)
signal purchase_store_item(store_item_name)
signal transgression_changed
signal caution_transgressions
signal warning_transgressions
signal game_over

@export var max_transgressions : int = 10
@export var starting_money : int = 0
@export var store_items = {
	"staff" : { "cost": 50, "scene": preload("res://scenes/picker_uppers/staff.tscn") },
	"boat" : { "cost": 250, "scene": preload("res://scenes/picker_uppers/boat.tscn") }
}
@export var max_time_to_next_storm : int = 45
@export var min_time_to_next_storm : int = 20
@export var storm_duration_time : int = 30
@export var spawn_rate : float = 2
@export var storm_spawn_rate : float = 0.4
@export var trash_credits : int = 5

var money : int = 0
var transgressions : int = 10
var score : int = 0

func _ready() -> void:
	money = starting_money
	_on_money_changed.emit(money)
	transgressions = max_transgressions
	score = 0
	transgression_changed.emit()

func credit_account() -> void:
	money += GameManager.trash_credits
	_on_money_changed.emit(money)

func debit_account(item_name : String) -> void:
	money -= GameManager.store_items.get(item_name).cost
	_on_money_changed.emit(money)
	purchase_store_item.emit(item_name)

func update_trangressions(count : int) -> void:
	#print("updating transgressions")
	transgressions = max_transgressions - count
	if transgressions <= 5:
		caution_transgressions.emit()
	if transgressions <= 2:
		warning_transgressions.emit()
	if transgressions <= 0:
		transgressions = 0
		score += money
		game_over.emit()
	transgression_changed.emit()

func game_start() -> void:
	_ready()

func _on_time_update(_time_value : int, time_increment : int):
	score += time_increment
	
func _on_storm_over():
	spawn_rate = spawn_rate/2
	storm_spawn_rate = storm_spawn_rate/2
	max_time_to_next_storm -= 2
	min_time_to_next_storm -= 2
