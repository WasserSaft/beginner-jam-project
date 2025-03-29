extends Control

@onready var dialog_line: RichTextLabel = $MarginContainer/DialogBox/MarginContainer/DialogLine
@onready var speaker_name: Label = $VBoxContainer2/SpeakerBox/MarginContainer2/SpeakerName

const ANIMATION_SPEED : int = 30
var animate_text : bool = false
var current_visible_characters : int = 0

func _ready():
	pass

func _process(delta):
	if animate_text:
		if current_visible_characters < dialog_line.text.length():
			current_visible_characters += ANIMATION_SPEED * delta
			dialog_line.visible_characters = int(current_visible_characters)
		else:
			dialog_line.visible_characters = dialog_line.text.length()
			animate_text = false

func change_line(speaker: String, line: String):
	speaker_name.text = speaker
	current_visible_characters = 0
	dialog_line.text = line
	dialog_line.visible_characters = 0
	dialog_line.visible_ratio = 0 
	animate_text = true
