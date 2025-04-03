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
	{ "speaker": "Uncle", "text": "Another case solved…" },
	{ "speaker": "Sergeant", "text": "Yeah, thanks a ton. Media’s gonna go crazy over the “circuses abducting animals” stuff." },
	{ "speaker": "Uncle", "text": "Through mirrors, that part is important. That tent was hiding an entire network of mirror portals to weird reflective dimensions that they use as training grounds." },
	{ "speaker": "Uncle", "text": "Pretty sure they were gonna build an evil mirror house. And all that reflection, inversion, whatever you call it, would’ve been bad news if I didn’t stop it single handedly." },
	{ "speaker": "Uncle", "text": "Anyway. The poor animals being taken from their families were promptly converted into crowbar wielding scallions." },
	{ "speaker": "Uncle", "text": "Whiiiiich, for the record, are now behind bars for assaulting an on-duty officer. Me." },
	{ "speaker": "Sergeant", "text": "Uh-huh… Really don’t think there's charges for that kind of conspiracy." },
	{ "speaker": "Uncle", "text": "Conspiracy to commit evil." },
	{ "speaker": "Sergeant", "text": "But I’m saying, that whole mirror stuff doesn’t make a lick of sense." },
	{ "speaker": "Uncle", "text": "I know what I saw boy… Now go tell the case officer I’ve got their culprits." },
	{ "speaker": "Sergeant", "text": "Alright… thanks Uncle." },
	{ "speaker": "Uncle", "text": "Uncle Detective. Really it’s just what I do." },
	{ "speaker": "Ringmaster", "text": "You… you are insane. Really… we didn’t do anything! Me and my posse’s been clowning since day one." },
	{ "speaker": "Ringmaster", "text": "I’m tellin’ ya, you’ve got the wrong guy! We’ve been set up! Please… please!" },
	{ "speaker": "Uncle", "text": "Tch tch tch…" },
	{ "speaker": "Hamsters", "text": "sniff… sniff… mista, please… my jugglin’ skills’ll go to waste in this cell…" },
	{ "speaker": "", "text": "Inside the trenchcoat, Nephew whispers up to Uncle as he holds him upon his shoulders." },
	{ "speaker": "Nephew", "text": "I really think they're telling the truth… this doesn’t feel right." },
	{ "speaker": "Uncle", "text": "If they’re telling the truth, why do the facts tell me they're lying? No one likes to be in jail. Everyone wants out." },
	{ "speaker": "Nephew", "text": "That’s the problem! They are literally powerless against your influen-" },
	{ "speaker": "Uncle", "text": "Shh! Quiet… No one can know you’re down there remember?" },
	{ "speaker": "Nephew", "text": "sigh…" }
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
