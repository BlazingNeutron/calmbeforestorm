extends Control

@onready var your_score: Label = $VBoxContainer/YourScore

func _on_restart_button_pressed() -> void:
	GameManager.start_game()
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_visibility_changed() -> void:
	your_score.text = "Score - " + str(GameManager.score)
