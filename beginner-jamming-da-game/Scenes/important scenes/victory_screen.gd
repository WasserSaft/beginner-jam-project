extends Node2D

#gets references from dialogUI node 
@onready var dialog_ui: Control = $CanvasLayer2/DialogUI
@onready var speaker_name: Label = dialog_ui.get_node("VBoxContainer2/SpeakerBox/MarginContainer2/SpeakerName")
@onready var dialog_line: RichTextLabel = dialog_ui.get_node("MarginContainer/DialogBox/MarginContainer/DialogLine")
@onready var background: TextureRect = $CanvasLayer/TextureRect

#keeps track of which line in the dialog we're on
var dialog_index : int = 0

#array of dialog lines with speaker names and text
const dialog_lines = [
	{ "speaker": "Nephew", "text": "Hope they’ve got candied apples. I think better after eating some sweets." }
]
var background_changes = {
	0: preload("res://Resources/PNGS/victoryscreen.png"),
}

func _ready():
	dialog_index = 0  #start from the first line in the array
	display_line(dialog_lines[dialog_index])  #show the first dialog line

func _input(event):
	if event.is_action_pressed("next_line"):
		#respond if DialogUI has finished typing
		if dialog_ui.type_timer.is_stopped():
			dialog_index += 1

			if dialog_index < dialog_lines.size():
				display_line(dialog_lines[dialog_index])
			else:
				#switch scene
				_change_scene()

#displays dialog lines on screen
func display_line(line_data: Dictionary):
	var speaker = line_data.get("speaker", "")
	var text = line_data.get("text", "")
	dialog_ui.change_line(speaker, text)
	if background_changes.has(dialog_index):
		$CanvasLayer/TextureRect.texture = background_changes[dialog_index]


func _change_scene():
	var next_scene = "res://Main Menu/titlescreen.tscn"
	get_tree().change_scene_to_file(next_scene)
