extends CharacterBody3D

@export var inventory_item: Inventory_item 

var dialog_ui: Node
var player_ref: Node

@onready var dialog_lines := [
	["Uncle", "No cracks in this mirror. But that’s it, that’s the gist of it. It’s how they get in…"],
	["Nephew", "Who? Who gets in? What are you talking about?"],
	["Uncle", "The mirror world, kid. You stare into a mirror too long, an those blurry figures start messing your face up... It’s why mirrors are bad luck."],
	["Uncle", "That’s why this circus is traveling around… they don’t want the government to see what they’re building."],
	["Nephew", "You need a mental evaluation! Who is “they” in this context!?"],
	["Uncle", "Oh yeah, put this in your pocket for me will you?"],
	["Nephew", "..."],
	["Nephew", "I hate this job."]
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
