extends CharacterBody3D

@export var inventory_item: Inventory_item 

var dialog_ui: Node
var player_ref: Node

@onready var dialog_lines := [
	["Uncle", "AHA! Classic mistake. They knew we were coming."],
	["Uncle", "And instead of putting this in the bin… they’ve left it for the ants."],
	["Uncle", "They’re hiding somewhere, that’s why they didn’t put it in the trash."],
	["Nephew", "So is that littering with intent then?"],
	["Uncle", "It’s sloppy work. I’m leaving it in your paws."],
	["Nephew", "It’s still got some soda in it…"],
	["Uncle", "Proves my point then."]
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
