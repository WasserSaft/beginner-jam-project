extends CharacterBody3D
@export var inventory_item: Inventory_item
func interact(player):
	var first_empty_slot = player.inventory.items.find(null, 0)
	if first_empty_slot == -1:
		print("full inventory")
	else:
		player.inventory.items[first_empty_slot] = inventory_item
		print(first_empty_slot)
