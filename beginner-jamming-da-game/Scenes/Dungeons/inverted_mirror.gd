extends CharacterBody3D

var dialog_ui: Node
var player_ref: Node

@onready var dialog_lines := [
	["Nephew", "Uh, Uncle... we can't go back through."],
	["Uncle", "There’s some clowns to put behind bars around here..."],
	["Nephew", "Yeah, think they'll let us out?"],
	["Uncle", "I'll make 'em."]
]


func interact(player):
	player_ref = player
	dialog_ui = get_tree().get_first_node_in_group("dialog_ui")

	if dialog_ui:
		dialog_ui.advance_on_input = true  
		dialog_ui.visible = true  
		dialog_ui.play_sequence(dialog_lines, _on_dialogue_finished)


func _on_dialogue_finished():
	if dialog_ui:
		dialog_ui.visible = false
