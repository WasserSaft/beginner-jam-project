extends CharacterBody3D

@export var inventory_item: Inventory_item 

var dialog_ui: Node
var player_ref: Node

@onready var dialog_lines := [
	["Uncle", "Here we go, implements that may have been used for… murder."],
	["Nephew", "Or, I dunno, juggling? Like it says in the name?"],
	["Nephew", "And wouldn’t they be, y’know… covered in blood?"],
	["Uncle", "Tucker down, young padawan… There's always more than meets the eye."],
	["Nephew", "You know what, fine. I’m pocketing ‘em."],
	["Nephew", "But I’m not convinced yet…"],
	["Uncle", "That’s how they get you."]
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
