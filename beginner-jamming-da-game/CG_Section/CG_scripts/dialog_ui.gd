extends Control

@onready var dialog_line: RichTextLabel = $MarginContainer/DialogBox/MarginContainer/DialogLine
@onready var speaker_name: Label = $VBoxContainer2/SpeakerBox/MarginContainer2/SpeakerName
@onready var type_timer: Timer = $TypeTimer

var full_text: String = ""
var char_index: int = 0

func _ready():
	type_timer.timeout.connect(_on_type_timer_timeout)

func change_line(speaker: String, line: String):
	speaker_name.text = speaker
	full_text = line
	char_index = 0
	dialog_line.text = ""
	type_timer.start()

func _on_type_timer_timeout():
	if char_index < full_text.length():
		dialog_line.text += full_text[char_index]
		char_index += 1
	else:
		type_timer.stop()
