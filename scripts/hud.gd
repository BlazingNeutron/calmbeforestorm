extends CanvasLayer

signal warning_completed

@onready var money_label: Label = %Money
@onready var storm: CanvasLayer = $Storm
@onready var warning: Node = $StormWarning
@onready var transgressions_meter: Label = %TransgressionsMeter
@onready var staff_button: Button = $StorePanel/StoreContainer/Staff
@onready var boat_button: Button = $StorePanel/StoreContainer/Boat
@onready var game_over_screen: Control = $GameOverScreen

func _ready() -> void:
	GameManager._on_money_changed.connect(update_money)
	GameManager.transgression_changed.connect(update_transgressions)
	GameManager.game_over.connect(_on_game_over)
	update_money(GameManager.money)
	warning.warning_complete.connect(_on_warning_completed)

func update_money(money : int) -> void:
	money_label.text = "$" + str(money)
	staff_button.disabled = (money < GameManager.store_items.staff.cost)
	boat_button.disabled = (money < GameManager.store_items.boat.cost)

func update_transgressions(count : int) -> void:
	transgressions_meter.text = str(count)

func _on_staff_pressed() -> void:
	#print("staff purchased")
	GameManager.debit_account("staff")

func _on_warning_completed() -> void:
	warning_completed.emit()

func _on_storm_warning() -> void:
	warning.start()

func _on_game_storming() -> void:
	storm.start()

func _on_game_clear_weather() -> void:
	storm.stop()

func _on_game_over() -> void:
	game_over_screen.show()

func _on_boat_pressed() -> void:
	GameManager.debit_account("boat")
