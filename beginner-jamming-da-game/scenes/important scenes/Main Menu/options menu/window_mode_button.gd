extends Control

@onready var option_button: OptionButton = $HBoxContainer/OptionButton

const WINDOW_MODES = [
	"Fullscreen",
	"Windowed",
	"Borderless Window",
	"Borderless Fullscreen"
]

func _ready():
	for mode in WINDOW_MODES:
		option_button.add_item(mode)

	option_button.item_selected.connect(_on_window_mode_selected)
	option_button.select(0)

func _on_window_mode_selected(index: int) -> void:
	var default_size := Vector2i(1280, 720)

	match index:
		0: # Fullscreen 
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
		1: # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_size(default_size)
			DisplayServer.window_set_position(Vector2i(100, 100))
			
		2: # Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_size(default_size)
			DisplayServer.window_set_position(Vector2i(0, 0))
			
		3: # Borderless Fullscreen
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
