extends CanvasLayer

signal warning_completed

@onready var money_label: Label = %Money
@onready var storm: CanvasLayer = $Storm
@onready var warning: Node = $StormWarning
@onready var staff_button: Button = $StorePanel/StoreContainer/Staff
@onready var boat_button: Button = $StorePanel/StoreContainer/Boat
@onready var game_over_screen: Control = $GameOverScreen
@onready var time_of_day: Label = %TimeOfDay
@onready var score_display: Label = %ScoreDisplay

var day_count = 1
var hour = 9
var minute = 0

func _ready() -> void:
	GameManager._on_money_changed.connect(update_money)
	GameManager.game_over.connect(_on_game_over)
	update_money(GameManager.money)
	warning.warning_complete.connect(_on_warning_completed)

func update_money(money : int) -> void:
	money_label.text = "$" + str(money)
	staff_button.disabled = (money < GameManager.store_items.staff.cost)
	boat_button.disabled = (money < GameManager.store_items.boat.cost)

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

func _on_game_time_update(time_score: int, _increment: int) -> void:
	if time_score % 60 == 0:
		hour += 1
		time_score = 0
	var minute_mod = (time_score/15) % 4
	if minute_mod >= 2:
		minute = 30
	else:
		minute = 0
	if hour >= 24:
		hour = 0
		day_count += 1
	time_of_day.text = "Day " + str(day_count) + " - " + ("%02d" % hour) + ":" + ("%02d" % minute)
	score_display.text = str(GameManager.score)
