extends Area3D
@export var boss: CharacterBody3D
@onready var dialog_ui = $"../DialogUI"  
@onready var boss_music: AudioStreamPlayer = $"../../BossMusic"
@onready var dungeon_music: AudioStreamPlayer = $"../../DungeonMusic"

var triggered := false


var boss_dialogue := [
	{ "speaker": "Ringmaster", "text": "You're done, boy." },
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
		if dungeon_music and dungeon_music.playing:
			dungeon_music.stop()
	if boss_music:
		boss_music.play()


func _on_dialogue_finished():
	boss.start_fight()
