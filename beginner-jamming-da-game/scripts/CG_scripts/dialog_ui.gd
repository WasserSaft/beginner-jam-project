extends Control

@onready var dialog_line: RichTextLabel = $MarginContainer/DialogBox/MarginContainer/DialogLine
@onready var speaker_name: Label = $VBoxContainer2/SpeakerBox/MarginContainer2/SpeakerName
@onready var type_timer: Timer = $TypeTimer
@export var advance_on_input := true
#full_text is entire sentence set to be typed, char_index tracks the character that is getting typed
var full_text: String = ""
var char_index: int = 0 
var is_sequence_playing := false

func _ready():
#connects the timer signal that runs every time it "ticks" for the animated effect
	type_timer.timeout.connect(_on_type_timer_timeout)
func _input(event):
	if event.is_action_pressed("next_line"):
		if type_timer.is_stopped():
			set_process_input(false)
			_next_line()
		else:
			type_timer.stop()
			dialog_line.text = full_text
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
		dialog_line.text += full_text[char_index]
		char_index += 1
	else:
		type_timer.stop()

		if advance_on_input:
			#wait for player click to advance
			set_process_input(true)
		else:
			#auto advance after short delay
			await get_tree().create_timer(0.5).timeout
			_next_line()

var dialog_queue: Array = []
var current_callback: Callable = func() -> void: pass

func play_sequence(lines: Array, finished_callback: Callable):
	dialog_queue = lines.duplicate()
	current_callback = finished_callback
	dialog_line.text = ""
	speaker_name.text = ""
	visible = true
	is_sequence_playing = true  
	set_process_input(true)
	_next_line()

func _next_line():
	if dialog_queue.size() > 0:
		var entry = dialog_queue.pop_front()

		var speaker := ""
		var text := ""

		if typeof(entry) == TYPE_DICTIONARY:
			speaker = entry.get("speaker", "")
			text = entry.get("text", "")
		elif typeof(entry) == TYPE_ARRAY and entry.size() >= 2:
			speaker = entry[0]
			text = entry[1]
		else:
			push_error("Invalid dialog entry format: " + str(entry))
			return

		change_line(speaker, text)

	elif is_sequence_playing:
		#only hide if this was a full sequence
		visible = false
		is_sequence_playing = false

		if current_callback != null:
			current_callback.call()
