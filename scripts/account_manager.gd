extends Node

signal _on_money_changed(money)
signal purchase_volunteer
signal transgression_changed(transgressions)

@export var starting_money : int = 0
@export var max_transgressions : int = 10
var money : int = 0
var transgressions : int = 10

func _ready() -> void:
	money = starting_money

func initialize() -> void:
	_on_money_changed.emit(money)

func credit_account() -> void:
	money += 5
	_on_money_changed.emit(money)

func debit_account() -> void:
	money -= 100
	_on_money_changed.emit(money)
	purchase_volunteer.emit()

func update_trangressions(count : int) -> void:
	#print("updating transgressions")
	transgressions = max_transgressions - count
	transgression_changed.emit(transgressions)
	if transgressions <= 0:
		game_over()

func game_over() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
