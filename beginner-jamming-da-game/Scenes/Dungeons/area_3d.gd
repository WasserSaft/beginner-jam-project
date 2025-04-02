extends Area3D

@onready var dialog_ui = $"../DialogUI"  
var triggered := false

var boss_dialogue := [
	{ "speaker": "Ringmaster", "text": "Your done boy." },
	{ "speaker": "Nephew", "text": "AHHHHHHHHHHHHH" },
]

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if triggered:
		return
	if body.name == "Player":
		trigger_dialogue()

func trigger_dialogue():
	triggered = true
	if dialog_ui and dialog_ui.has_method("play_sequence"):
		dialog_ui.play_sequence(boss_dialogue, _on_dialogue_finished)

func _on_dialogue_finished():
	pass #This is the spot to start the bossfight
