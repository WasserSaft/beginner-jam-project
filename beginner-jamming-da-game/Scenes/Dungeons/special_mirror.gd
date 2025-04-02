extends CharacterBody3D

@export var target_scene_path: String = "res://Scenes/Dungeons/dungeon_2.tscn"

var dialog_ui: Node
var player_ref: Node

@onready var dialog_lines := [
	["Uncle", "Looks like we’ve found what we’re looking for."],
	["Nephew", "Are we ready to move on?"],
	["Uncle", "Let's go."]
]

func interact(player):
	print("Interact called!")
	player_ref = player
	dialog_ui = get_tree().get_first_node_in_group("dialog_ui")

	if dialog_ui:
		print("Found dialog_ui:", dialog_ui)
		dialog_ui.advance_on_input = true  
		dialog_ui.play_sequence(dialog_lines, _on_dialogue_finished)
	else:
		print("No dialog UI found, skipping to scene change")
		_on_dialogue_finished()


func _on_dialogue_finished():
	print("Dialogue finished. Switching scene...")
	if target_scene_path != "":
		var err = get_tree().change_scene_to_file(target_scene_path)
		if err != OK:
			print("Scene change failed with error:", err)
	else:
		print("No target scene path set.")
