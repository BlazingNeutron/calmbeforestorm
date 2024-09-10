extends CanvasLayer

@onready var lightning: CanvasLayer = $lightning
@onready var money_label: Label = %Money
@onready var storm_warning_icon: Node = $StormWarning
@onready var transgressions_meter: Label = %TransgressionsMeter
@onready var staff_button: Button = $StorePanel/StoreContainer/Staff

func _ready() -> void:
	AccountManager._on_money_changed.connect(update_money)
	AccountManager.transgression_changed.connect(update_transgressions)
	update_money(AccountManager.money)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("test_lightning"):
		lightning.lightning_strike()

func update_money(money : int) -> void:
	money_label.text = "$" + str(money)
	staff_button.disabled = (money < 50)

func update_transgressions(count : int) -> void:
	transgressions_meter.text = str(count)

func storm_warning() -> void:
	storm_warning_icon.start_storm_warning()

func _on_volunteer_pressed() -> void:
	#print("volunteer purchased")
	AccountManager.debit_account()
