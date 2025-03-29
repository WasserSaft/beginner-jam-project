extends Node2D

@onready var dialog_ui: Control = $CanvasLayer2/DialogUI
@onready var speaker_name: Label = dialog_ui.get_node("VBoxContainer2/SpeakerBox/MarginContainer2/SpeakerName")
@onready var dialog_line: RichTextLabel = dialog_ui.get_node("MarginContainer/DialogBox/MarginContainer/DialogLine")

var dialog_index : int = 0

const dialog_lines = [
	{ "speaker": "Snake", "text": "This Uncle Detective Private Investigations?" },
	{ "speaker": "Nephew", "text": "Yeah, you have the right number." },
	{ "speaker": "Snake", "text": "Great. Route 9. Steel mill. Tent town full’a travelin’ beasts. Folks goin’ missin’. No flesh. No bones. Just... poof." },
	{ "speaker": "Snake", "text": "Cops can’t get near it without catchin’ elbows from clowns with crowbars." },
	{ "speaker": "Snake", "text": "...Figured it’s the kind of place that reels in types like your lead investigator. One way or another." },
	{ "speaker": "Nephew", "text": "Okay, thanks. Uh, we’ll let him know." },
	{ "speaker": "Snake", "text": "Knew you would. ‘Cause once Uncle Detective comes knockin’... nobody leaves on their own termsss." },
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
	{ "speaker": "Nephew", "text": "On a hot plate we use for drying out wet case files?! …And your- ugh, your sweaty socks?" },
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
	{ "speaker": "Uncle", "text": "Ringmasters know everything. You don’t run a tent full of sociopaths and acrobats without knowing what they’re hiding…" },
	{ "speaker": "Nephew", "text": "You think we’ll find those missing animals, or just a bunch of sad graduates from clown school?" },
	{ "speaker": "Uncle", "text": "Doesn’t matter… This is the trail, we need to follow it. It always leads us somewhere." },
	{ "speaker": "Nephew", "text": "Yeah… that's the part that worries me." },
	{ "speaker": "Nephew", "text": "If that’s it, I’ll go put our stuff in the trunk." },
	{ "speaker": "Uncle", "text": "Make sure you’ve got those pants on with extra pockets. Oh, and the trench coat for afterwards when we inevitably put those crooks behind bars." },
	{ "speaker": "Nephew", "text": "Heh, right. Just a normal day." },
	{ "speaker": "Uncle", "text": "Exaactly!" },
	{ "speaker": "Nephew", "text": "Hope they’ve got candied apples. I think better after eating some sweets." }
]





func _ready():
	dialog_index = 0
	display_line(dialog_lines[dialog_index])

func _input(event):
	if event.is_action_pressed("next_line"):
		if dialog_index < dialog_lines.size() - 1:
			dialog_index += 1
			display_line(dialog_lines[dialog_index])

func display_line(line_data: Dictionary):
	var speaker = line_data.get("speaker", "")
	var text = line_data.get("text", "")
	dialog_ui.change_line(speaker, text)
