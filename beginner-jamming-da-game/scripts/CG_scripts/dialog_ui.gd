extends Control

@onready var dialog_line: RichTextLabel = $MarginContainer/DialogBox/MarginContainer/DialogLine
@onready var speaker_name: Label = $VBoxContainer2/SpeakerBox/MarginContainer2/SpeakerName
@onready var type_timer: Timer = $TypeTimer

#full_text is entire sentence set to be typed, char_index tracks the character that is getting typed
var full_text: String = ""
var char_index: int = 0 

func _ready():
#connects the timer signal that runs every time it "ticks" for the animated effect
	visible = false
	type_timer.timeout.connect(_on_type_timer_timeout)
#for when a new dialog line needs to be shown
func change_line(speaker: String, line: String):
	speaker_name.text = speaker    #updatea the speaker name label
	full_text = line               #stores the entire line of dialog wanted to display
	char_index = 0                 #starts typing from the beginning
	dialog_line.text = ""          #clears the dialog box before typing starts
	type_timer.start()             #starts the timer to begin the typewriter effect

#uses the timer tick in inspector so .05
func _on_type_timer_timeout():
	if char_index < full_text.length():
		#adds the next character to the dialog box
		dialog_line.text += full_text[char_index]
		char_index += 1  #moves to the next character
	else:
		#after whole dialog text is there, the animated effect stops
		type_timer.stop()
		await get_tree().create_timer(0.4).timeout  # pause before next line
		_next_line()

var dialog_queue: Array = []
var current_callback: Callable = func() -> void: pass

func play_sequence(lines: Array, finished_callback: Callable):
	dialog_queue = lines.duplicate()
	current_callback = finished_callback
	visible = true  # <-- show dialog box
	_next_line()

func _next_line():
	if dialog_queue.size() > 0:
		var entry = dialog_queue.pop_front()
		change_line(entry[0], entry[1])
	else:
		visible = false  # <-- hide the box when done
		if current_callback != null:
			current_callback.call()
