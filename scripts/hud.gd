extends CanvasLayer

@onready var money_label: Label = %Money
@onready var staff_button: Button = $StorePanel/StoreContainer/Staff
@onready var boat_button: Button = $StorePanel/StoreContainer/Boat
@onready var time_of_day: Label = %TimeOfDay
@onready var score_display: Label = %ScoreDisplay

var day_count = 1
var hour = 9
var minute = 0

func _ready() -> void:
	GameManager.game_start.connect(_on_game_start)
	GameManager.money_changed.connect(update_money)
	GameManager.time_update.connect(_on_game_time_update)

func _on_game_start() -> void:
	update_money()
	update_time_display()

func update_money() -> void:
	var money = GameManager.money
	money_label.text = "$" + str(money)
	staff_button.disabled = (money < GameManager.store_items.staff.cost)
	boat_button.disabled = (money < GameManager.store_items.boat.cost)
	boat_button.disabled = (money < GameManager.store_items.regen.cost)

func update_time_display() -> void:
	if GameManager.time_of_day % 60 == 0:
		hour += 1
	var minute_mod = int((GameManager.time_of_day % 60)/15.0) % 4
	if minute_mod >= 2:
		minute = 30
	else:
		minute = 0
	if hour >= 24:
		hour = 0
		day_count += 1
	time_of_day.text = "Day " + str(day_count) + " - " + ("%02d" % hour) + ":" + ("%02d" % minute)
	score_display.text = str(GameManager.score + GameManager.money)

func _on_staff_pressed() -> void:
	#print("staff purchased")
	GameManager.debit_account("staff")

func _on_boat_pressed() -> void:
	GameManager.debit_account("boat")

func _on_game_time_update(_increment: int) -> void:
	update_time_display()


func _on_health_regen_pressed() -> void:
	GameManager.debit_account("regen")
