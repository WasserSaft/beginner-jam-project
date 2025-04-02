extends CharacterBody3D

@export var target_scene_path: String = "res://Scenes/Dungeons/dungeon_2.tscn"

var dialog_ui: Node
var player_ref: Node

@onready var dialog_lines := [
	["Uncle", "Holy mackerel... That’s it. My hunch about the mirrors was right."],
	["Nephew", "Wait, really?"],
	["Uncle", "Nephew, look at that black indent at the base. Clearly they’ve been abducting the missing animals and taking them through this mirror!"],
	["Nephew", "…Through the mirror?"],
	["Uncle", "Yes! That’s why so many of the smaller ones were broken! They were getting rid of the ones that didn’t work."],
	["Nephew", "I dunno… I figured they just broke a lot of mirrors. Clowns are clumsy."],
	["Uncle", "Don’t be naive. It’s suspicious."],
	["Narration", "[He reaches toward the mirror, his finger sinking slightly into the surface.]"],
	["Uncle", "Aha! Yup. My pinky is phasing through the glass. Here we go."],
	["Nephew", "Okay… this is weird, but fine. I’ll just set down our clues on the Ringmaster’s desk as we’re about to walk into a totally real magical mirror dimension."]
]


func interact(player):
	player_ref = player
	dialog_ui = get_tree().get_first_node_in_group("dialog_ui")

	if dialog_ui:
		dialog_ui.advance_on_input = true  
		dialog_ui.play_sequence(dialog_lines, _on_dialogue_finished)
	else:
		_on_dialogue_finished()

func _on_dialogue_finished():
	if dialog_ui:
		dialog_ui.visible = false

	await get_tree().create_timer(0.7).timeout

	if target_scene_path != "":
		get_tree().change_scene_to_file(target_scene_path)
