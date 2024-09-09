extends Node

signal _on_money_changed(money)
signal purchase_volunteer

@export var starting_money : 	int = 100
var money : int = 0

func _ready() -> void:
	money = starting_money

func credit_account() -> void:
	money += 5
	_on_money_changed.emit(money)

func debit_account() -> void:
	money -= 100
	_on_money_changed.emit(money)
	purchase_volunteer.emit()
