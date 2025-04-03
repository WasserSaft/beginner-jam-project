extends Node2D

#gets references from dialogUI node 
@onready var dialog_ui: Control = $CanvasLayer2/DialogUI
@onready var speaker_name: Label = dialog_ui.get_node("VBoxContainer2/SpeakerBox/MarginContainer2/SpeakerName")
@onready var dialog_line: RichTextLabel = dialog_ui.get_node("MarginContainer/DialogBox/MarginContainer/DialogLine")
@onready var background: TextureRect = $CanvasLayer/Background

#keeps track of which line in the dialog we're on
var dialog_index : int = 0

#array of dialog lines with speaker names and text
const dialog_lines = [
	{ "speaker": "???", "text": "This Uncle Detective Private Investigations?" },
	{ "speaker": "Nephew", "text": "Yeah, you have the right number." },
	{ "speaker": "???", "text": "'Kay then. Route 9. Steel mill. Tent town full’a travelin’ beasts. Folks goin’ missin’. No flesh. No bones. Just... poof." },
	{ "speaker": "???", "text": "Cops can’t get near it without catchin’ elbows from clowns with crowbars." },
	{ "speaker": "???", "text": "...Figured it’s the kind of place that reels in types like your lead guy. One way or another." },
	{ "speaker": "Nephew", "text": "Okay, thanks. Uh, we’ll let him know." },
	{ "speaker": "???", "text": "Knew you would. ‘Cause once Uncle Detective comes knockin’..." },
	{ "speaker": "???", "text": "Itsss" },
	{ "speaker": "???", "text": "game" },
	{ "speaker": "???", "text": "over." },
	{ "speaker": "", "text": "Click" },
	{ "speaker": "Nephew", "text": "Huh…" },
	{ "speaker": "Uncle", "text": "Ahem." },
	{ "speaker": "Nephew", "text": "Reptile again. Circus by Route 9, old steel mill. Says animals are vanishing. Cops won’t touch it." },
	{ "speaker": "Uncle", "text": "Oho…" },
	{ "speaker": "Nephew", "text": "He’s been dropping us a lot of tips lately. Too many. I dunno. Feels off…" },
	{ "speaker": "Nephew", "text": "...Also, I’m pretty sure he’s calling from the same busted payphone every time. Always sounds like he’s inside of a wind tunnel… or by the city bus stop." },
	{ "speaker": "Uncle", "text": "Mmmm…" },
	{ "speaker": "Nephew", "text": "You're catching all this, right?" },  
	{ "speaker": "Uncle", "text": "Looks right…" },
	{ "speaker": "Nephew", "text": "What the hell are you doing?" },
	{ "speaker": "Uncle", "text": "Trying to boil an egg." },
	{ "speaker": "Nephew", "text": "On the hot plate we use for drying out wet case files?! …And your- ugh, your sweaty socks?" },
	{ "speaker": "Uncle", "text": "Boiling eggs and case files are similar in composition my friend…" },
	{ "speaker": "Nephew", "text": "Uncle…every time I think I start understanding your process, you start doing stuff like this. Insurance isn’t going to cover the sickness you’ll get from eating that." },
	{ "speaker": "Uncle", "text": "Insurance? Don’t make me laugh... Anyway, sure, circuses. Let’s talk about that." },
	{ "speaker": "Uncle", "text": "Nobodies gonna up and vanish without help these days." },
	{ "speaker": "Uncle", "text": "Steel mill’s a good spot. Nearby, secluded. Easy to sell a ticket, rob someone blind, and bury what’s left underneath it." },
	{ "speaker": "Uncle", "text": "...get me my clown files, Nephew." },
	{ "speaker": "Nephew", "text": "Okay, but I really wish that wasn’t a real drawer…" },
	{ "speaker": "Uncle", "text": "Where else would we keep the transcript from the ‘95 subway mime sting?" },
	{ "speaker": "Nephew", "text": "Right… we yelled at a bunch of mimes in public for three hours. Then you broke down in tears after they didn’t break character even once." },
	{ "speaker": "Uncle", "text": "I’ve still got a score to settle dammit..." },
	{ "speaker": "Nephew", "text": "So… what's the plan this time?" },
	{ "speaker": "Uncle", "text": "We go in quietly. No badges, no questions. Just two rabbits at a circus." },
	{ "speaker": "Uncle", "text": "Blend in. Buy some popcorn. Break a lock or two. We slip inside, pick through their likely numerous belongings, and head to the Ringmasters office." },
	{ "speaker": "Nephew", "text": "The Ringmaster is our lead then?" },
	{ "speaker": "Uncle", "text": "Ringmasters know everything. You don’t run a tent full of sociopathic clowns without knowing what they’re hiding…" },
	{ "speaker": "Nephew", "text": "You think we’ll find those missing animals, or just a bunch of sad graduates from clown school?" },
	{ "speaker": "Uncle", "text": "Doesn’t matter… This is the trail, we need to follow it. It always leads us somewhere." },
	{ "speaker": "Nephew", "text": "Yeah… that's the part that worries me." },
	{ "speaker": "Nephew", "text": "If that’s it, I’ll go put our stuff in the trunk." },
	{ "speaker": "Uncle", "text": "Make sure you’ve got those pants on with extra pockets. Oh, and the trench coat for afterwards when we inevitably put those crooks behind bars." },
	{ "speaker": "Nephew", "text": "Heh, right. Just a normal day." },
	{ "speaker": "Uncle", "text": "Exaactly!" },
	{ "speaker": "Nephew", "text": "Hope they’ve got candied apples. I think better after eating some sweets." }
]
var background_changes = {
	0: preload("res://Resources/PNGS/Scene1.png"),
	11: preload("res://Resources/PNGS/Scene2.png"),
	21: preload("res://Resources/PNGS/Scene3.png"),
	26: preload("res://Resources/PNGS/Scene4.png"),
	41: preload("res://Resources/PNGS/finalcg.png")
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
		$CanvasLayer/Background.texture = background_changes[dialog_index]


func _change_scene():
	var next_scene = "res://Scenes/Dungeons/Dungeon1.tscn"
	get_tree().change_scene_to_file(next_scene)
