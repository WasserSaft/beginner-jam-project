extends Control
class_name main_menu

@onready var start_game: Button = $MarginContainer/VBoxContainer/Start_Game
@onready var options_button: Button = $MarginContainer/VBoxContainer/Options_Button
@onready var exit_game: Button = $MarginContainer/VBoxContainer/Exit_Game
const start_level = preload("res://Scenes/CG_scenes/main_scene.tscn")
@onready var options_menu = $Options_Menu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer
@onready var hoversfx: AudioStreamPlayer = $Hoversfx

func _ready():
	for button in get_tree().get_nodes_in_group("ui_button"):
		button.mouse_entered.connect(_on_button_mouse_entered)
	handle_connecting_signals()

func _on_button_mouse_entered():
	hoversfx.play()

func handle_connecting_signals():
	start_game.button_down.connect(on_start_pressed)
	options_button.button_down.connect(on_options_pressed)
	exit_game.button_down.connect(on_exit_game_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func on_exit_game_pressed() -> void:
	get_tree().quit()

func on_exit_options_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false

func on_exit_settings() -> void:
	pass
