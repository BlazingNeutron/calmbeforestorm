extends Control

signal close_pause_menu

@onready var title: RichTextLabel = $Title
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var settings: Control = $Settings
@onready var high_score_container: VBoxContainer = $HighScoreContainer

func _on_options_pressed() -> void:
	v_box_container.visible = !v_box_container.visible
	settings.visible = !settings.visible

func _on_settings_close_settings() -> void:
	v_box_container.visible = !v_box_container.visible
	settings.visible = !settings.visible

func _on_high_scores_pressed() -> void:
	title.visible = !title.visible
	v_box_container.visible = !v_box_container.visible
	high_score_container.visible = !high_score_container.visible

func _on_high_score_display_close_score() -> void:
	title.visible = !title.visible
	v_box_container.visible = !v_box_container.visible
	high_score_container.visible = !high_score_container.visible

func _on_restart_pressed() -> void:
	close_pause_menu.emit()
	GameManager.stop_game(true)
	GameManager.start_game()
	get_tree().reload_current_scene()

func _on_return_to_menu_pressed() -> void:
	close_pause_menu.emit()
	GameManager.stop_game(true)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_back_to_game_pressed() -> void:
	close_pause_menu.emit()
