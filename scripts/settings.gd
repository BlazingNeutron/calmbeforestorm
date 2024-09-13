extends Control

signal close_settings

@onready var audio_test_player: AudioStreamPlayer = $AudioTestPlayer

@onready var master_volume: HSlider = $MarginContainer/VBoxContainer/MasterVolumeControls/MasterVolume
@onready var master_mute_checkbox: CheckBox = $MarginContainer/VBoxContainer/MasterVolumeControls/MasterMuteCheckbox
@onready var master_mute_icon: TextureRect = $MarginContainer/VBoxContainer/MasterVolumeControls/MasterMuteIcon
@onready var ocean_volume: HSlider = $MarginContainer/VBoxContainer/OceanVolumeControls/OceanVolume
@onready var ocean_mute_checkbox: CheckBox = $MarginContainer/VBoxContainer/OceanVolumeControls/OceanMuteCheckbox
@onready var ocean_mute_icon: TextureRect = $MarginContainer/VBoxContainer/OceanVolumeControls/OceanMuteIcon
@onready var music_volume: HSlider = $MarginContainer/VBoxContainer/MusicVolumeContainer/MusicVolume
@onready var music_mute_checkbox: CheckBox = $MarginContainer/VBoxContainer/MusicVolumeContainer/MusicMuteCheckbox
@onready var music_mute_icon: TextureRect = $MarginContainer/VBoxContainer/MusicVolumeContainer/MusicMuteIcon
@onready var sfx_volume: HSlider = $MarginContainer/VBoxContainer/SFXVolumeContainer/SFXVolume
@onready var sfx_mute_checkbox: CheckBox = $MarginContainer/VBoxContainer/SFXVolumeContainer/SFXMuteCheckbox
@onready var sfx_mute_icon: TextureRect = $MarginContainer/VBoxContainer/SFXVolumeContainer/SFXMuteIcon

@export var MASTER : int = 0
@export var OCEAN : int = 1
@export var MUSIC : int = 2
@export var SFX : int = 3
@export var bus_name : Array = [ "MASTER", "Ocean Sounds", "Music", "SFX" ]

var ICON_MUTED : int = 32
var ICON_0 : int = 64
var ICON_25 : int = 96
var ICON_50 : int = 128
var ICON_75 : int = 160
var ICON_100 : int = 192

var initializing = true

func _ready() -> void:
	master_volume.value = db_to_linear(AudioServer.get_bus_volume_db(MASTER))
	update_icon(MASTER, master_mute_icon)
	ocean_volume.value = db_to_linear(AudioServer.get_bus_volume_db(OCEAN))
	update_icon(OCEAN, ocean_mute_icon)
	music_volume.value = db_to_linear(AudioServer.get_bus_volume_db(MUSIC))
	update_icon(MUSIC, music_mute_icon)
	sfx_volume.value = db_to_linear(AudioServer.get_bus_volume_db(SFX))
	update_icon(SFX, sfx_mute_icon)
	initializing = false

func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MASTER, linear_to_db(value))
	update_icon(MASTER, master_mute_icon)

func _on_master_mute_checkbox_toggled(toggled_on: bool) -> void:
	#print("toggling")
	AudioServer.set_bus_mute(MASTER, toggled_on)
	update_icon(MASTER, master_mute_icon)

func _on_master_mute_icon_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('action'):
			#print("trying to toggle")
			master_mute_checkbox.button_pressed = !master_mute_checkbox.button_pressed
			AudioServer.set_bus_mute(MASTER, master_mute_checkbox.button_pressed)
			update_icon(MASTER, master_mute_icon)

func update_icon(bus : int, icon : TextureRect) -> void:
	convert_slider_value_to_icon(
		db_to_linear(AudioServer.get_bus_volume_db(bus)), 
		AudioServer.is_bus_mute(bus), 
		icon)
	audio_test_player.bus = bus_name[bus]
	if not initializing:
		audio_test_player.play()

func convert_slider_value_to_icon(value: float, muted: bool, icon: TextureRect) -> void:
	if value == 1.0:
		icon.texture.region.position.x = ICON_100
	elif value > 0.75:
		icon.texture.region.position.x = ICON_75
	elif value > 0.5:
		icon.texture.region.position.x = ICON_50
	elif value > 0.25:
		icon.texture.region.position.x = ICON_25
	elif value > 0:
		icon.texture.region.position.x = ICON_0
	if value == 0 or muted:
		icon.texture.region.position.x = ICON_MUTED

func _on_ocean_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(OCEAN, linear_to_db(value))
	update_icon(OCEAN, ocean_mute_icon)

func _on_ocean_mute_checkbox_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(OCEAN, toggled_on)
	update_icon(OCEAN, ocean_mute_icon)

func _on_ocean_mute_icon_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('action'):
			ocean_mute_checkbox.button_pressed = !ocean_mute_checkbox.button_pressed
			AudioServer.set_bus_mute(OCEAN, ocean_mute_checkbox.button_pressed)
			update_icon(OCEAN, ocean_mute_icon)

func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MUSIC, linear_to_db(value))
	update_icon(MUSIC, music_mute_icon)

func _on_music_mute_checkbox_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(MUSIC, toggled_on)
	update_icon(MUSIC, music_mute_icon)

func _on_music_mute_icon_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('action'):
			music_mute_checkbox.button_pressed = !music_mute_checkbox.button_pressed
			AudioServer.set_bus_mute(MUSIC, music_mute_checkbox.button_pressed)
			update_icon(MUSIC, music_mute_icon)

func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFX, linear_to_db(value))
	update_icon(SFX, sfx_mute_icon)

func _on_sfx_mute_checkbox_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(SFX, toggled_on)
	update_icon(SFX, sfx_mute_icon)

func _on_sfx_mute_icon_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed('action'):
			sfx_mute_checkbox.button_pressed = !sfx_mute_checkbox.button_pressed
			AudioServer.set_bus_mute(SFX, sfx_mute_checkbox.button_pressed)
			update_icon(SFX, sfx_mute_icon)

func _on_button_pressed() -> void:
	#print("closing pause menu")
	close_settings.emit()


func _on_options_pressed() -> void:
	pass # Replace with function body.
