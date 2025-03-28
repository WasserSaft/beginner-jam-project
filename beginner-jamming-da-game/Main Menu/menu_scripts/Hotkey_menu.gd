extends MarginContainer

@onready var hotkey_container = $ScrollContainer/VBoxContainer
@export var hotkey_button_scene: PackedScene  

var actions = ["move_up", "move_down", "move_left", "move_right", "jump"]

func _ready():
	for action in actions:
		var button_instance = hotkey_button_scene.instantiate()
		button_instance.action_name = action
		button_instance.add_to_group("hotkey_button")
		hotkey_container.add_child(button_instance)
