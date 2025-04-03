extends Area3D
@export var boss: CharacterBody3D
@onready var dialog_ui = $"../DialogUI"  
@onready var boss_music: AudioStreamPlayer = $"../../BossMusic"
@onready var dungeon_music: AudioStreamPlayer = $"../../DungeonMusic"

var triggered := false


var boss_dialogue := [
	{ "speaker": "Uncle", "text": "Heh, clever contraption buddy… but you can’t fool me." },
	{ "speaker": "Ringmaster", "text": "Ho? Didja get a backstage pass?" },
	{ "speaker": "Uncle", "text": "Pah! We didn’t come for the circus. Where are those animals?!" },
	{ "speaker": "Ringmaster", "text": "Oh… so you’re trespassing. An my boys didn’t kick ya out yet?" },
	{ "speaker": "Nephew", "text": "Uncle… I have a bad feeling." },
	{ "speaker": "Uncle", "text": "I’m getting old but I’ve still got some bite in me…" },
	{ "speaker": "Ringmaster", "text": "Seems like I gotta kick you out myself..." }
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
