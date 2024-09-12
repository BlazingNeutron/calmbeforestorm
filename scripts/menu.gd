extends Control

@onready var settings: Control = $Settings
@onready var v_box_container: VBoxContainer = $VBoxContainer

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

func _on_settings_visibility_changed() -> void:
	if not settings.visible:
		v_box_container.visible = !v_box_container.visible
