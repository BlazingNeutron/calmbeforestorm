extends CanvasLayer

signal warning_completed

@onready var money_label: Label = %Money
@onready var storm: CanvasLayer = $Storm
@onready var warning: Node = $StormWarning
@onready var transgressions_meter: Label = %TransgressionsMeter
@onready var staff_button: Button = $StorePanel/StoreContainer/Staff

func _ready() -> void:
	AccountManager._on_money_changed.connect(update_money)
	AccountManager.transgression_changed.connect(update_transgressions)
	update_money(AccountManager.money)
	warning.warning_complete.connect(_on_warning_completed)

func update_money(money : int) -> void:
	money_label.text = "$" + str(money)
	staff_button.disabled = (money < 50)

func update_transgressions(count : int) -> void:
	transgressions_meter.text = str(count)

func _on_staff_pressed() -> void:
	#print("staff purchased")
	AccountManager.debit_account()

func _on_warning_completed() -> void:
	warning_completed.emit()

func _on_storm_warning() -> void:
	warning.start()

func _on_game_storming() -> void:
	storm.start()

func _on_game_clear_weather() -> void:
	storm.stop()
