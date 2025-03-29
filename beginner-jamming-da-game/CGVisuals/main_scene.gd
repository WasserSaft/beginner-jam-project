extends Node2D

@onready var dialog_ui: Control = $CanvasLayer2/DialogUI
@onready var speaker_name: Label = dialog_ui.get_node("VBoxContainer2/SpeakerBox/MarginContainer2/SpeakerName")
@onready var dialog_line: RichTextLabel = dialog_ui.get_node("MarginContainer/DialogBox/MarginContainer/DialogLine")

var dialog_index : int = 0

const dialog_lines : Array[String] = [
	"Snake: This Uncle Detective Private Investigations?",
	"Nephew: Yeah, you have the right number."
]

func _ready():
	dialog_index = 0
	display_line(dialog_lines[dialog_index])

func _input(event):
	if event.is_action_pressed("next_line"):
		if dialog_index < dialog_lines.size() - 1:
			dialog_index += 1
			display_line(dialog_lines[dialog_index])

func display_line(line: String):
	var line_info = parse_line(line)
	dialog_ui.change_line(line_info["speaker_name"], line_info["dialog_line"])

func parse_line(line: String) -> Dictionary:
	var parts = line.split(":")
	assert(parts.size() >= 2)
	return {
		"speaker_name": parts[0].strip_edges(),
		"dialog_line": parts[1].strip_edges()
	}
