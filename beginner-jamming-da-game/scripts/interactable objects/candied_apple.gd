extends CharacterBody3D

@export var inventory_item: Inventory_item 

var dialog_ui: Node
var player_ref: Node

@onready var dialog_lines := [
	["Nephew", "A candied apple!! Yippee!"],
	["Uncle", "DO NOT eat that. It’s evidence."],
	["Nephew", "How could this possibly be connected to the case!?"],
	["Uncle", "It’s obviously laced with poison. Clowns are always lacing their stuff."],
	["Nephew", "... but I was really looking forward to this."],
	["Uncle", "Keep your head in the game and put that in your pocket."],
	["Nephew", "What a waste of a treat."]
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
	var first_empty_slot = player_ref.inventory.items.find(null, 0)
	if first_empty_slot == -1:
		print("full inventory")
	else:
		player_ref.inventory.items[first_empty_slot] = inventory_item
		print(first_empty_slot)

		var hud = get_tree().get_first_node_in_group("hud")
		if hud:
			hud.update_inventory()

	queue_free()
