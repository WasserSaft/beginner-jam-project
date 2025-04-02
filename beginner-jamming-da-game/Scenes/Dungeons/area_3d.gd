extends Area3D
@export var boss: CharacterBody3D
@onready var dialog_ui = $"../DialogUI"  
var triggered := false
var half_health_triggered := false


var boss_dialogue := [
	{ "speaker": "Ringmaster", "text": "You're done, boy." },
	{ "speaker": "Nephew", "text": "AHHHHHHHHHHHHH" },
]

var half_health_dialogue := [
	{ "speaker": "Ringmaster", "text": "Hoho, your done now!" },
]

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if triggered:
		return
	if body.name == "Player":
		trigger_dialogue()


func _input(event):
	#press H to trigger the half-health dialogue 
	if event.is_action_pressed("debug_half_health"):
		trigger_half_health_dialogue()

func trigger_dialogue():
	triggered = true
	if dialog_ui and dialog_ui.has_method("play_sequence"):
		dialog_ui.play_sequence(boss_dialogue, _on_dialogue_finished)

func trigger_half_health_dialogue():
	if half_health_triggered:
		return
	half_health_triggered = true
	if dialog_ui and dialog_ui.has_method("play_sequence"):
		dialog_ui.play_sequence(half_health_dialogue, _on_half_health_dialogue_finished)

func _on_dialogue_finished():
	boss.start_fight()

func _on_half_health_dialogue_finished():
	pass
