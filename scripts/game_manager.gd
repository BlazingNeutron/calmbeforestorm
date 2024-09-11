extends Node

signal _on_money_changed(money)
signal purchase_store_item(store_item_name)
signal transgression_changed(transgressions)
signal caution_transgressions
signal warning_transgressions
signal game_over

@export var max_transgressions : int = 10
@export var starting_money : int = 250
@export var store_items = {
	"staff" : { "cost": 50, "scene": preload("res://scenes/picker_uppers/staff.tscn") },
	"boat" : { "cost": 250, "scene": preload("res://scenes/picker_uppers/boat.tscn") }
}

var money : int = 0
var transgressions : int = 10

func _ready() -> void:
	money = starting_money
	transgressions = max_transgressions

func credit_account() -> void:
	money += 5
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
		game_over.emit()
	transgression_changed.emit(transgressions)

func game_start() -> void:
	_ready()
