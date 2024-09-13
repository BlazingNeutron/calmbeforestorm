extends Control

@onready var settings: Control = $Settings
@onready var v_box_container: VBoxContainer = $VBoxContainer
@onready var title: RichTextLabel = $Title
@onready var high_score_container: VBoxContainer = $HighScoreContainer

var paused = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Start.grab_focus()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

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
