extends Control
@export var player: Node
@onready var inventory: VBoxContainer = $inventory
@onready var hp_container: HBoxContainer = $"hp container"
@onready var dialog_ui: Control = $DialogUI

const HEALTH_ICON = preload("res://scenes/ui/hud/health_icon.tscn")

func _ready() -> void:
	display_hp()
	update_inventory()
	dialog_ui.visible = false
func display_hp():
	for child in hp_container.get_children():
		child.queue_free()
	for i in player.stats.hp:
		var hp_icon= HEALTH_ICON.instantiate()
		hp_container.add_child(hp_icon)

#invetory
@onready var inventory_container = $VBoxContainer
@onready var player_node = $"../.."

const ITEM_SLOT_SCENE = preload("res://scenes/ui/hud/inventory/item_slot.tscn")

func update_inventory():
	#clear existing icons
	for child in inventory_container.get_children():
		child.queue_free()

	#add new slots for each item
	for item in player.inventory.items:
		if item != null:
			var item_slot = ITEM_SLOT_SCENE.instantiate()
			item_slot.set_icon(item.sprite)
			inventory_container.add_child(item_slot)

func show_dialogue(speaker: String, line: String):
	dialog_ui.visible = true
	dialog_ui.change_line(speaker, line)
