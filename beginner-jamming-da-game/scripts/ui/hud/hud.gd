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

func update_inventory():
	var slots = inventory.get_children()
	for slot_index in slots.size():
		if player.inventory.items[slot_index] != null:
			slots[slot_index].get_child(0).texture = player.inventory.items[slot_index].sprite

func show_dialogue(speaker: String, line: String):
	dialog_ui.visible = true
	dialog_ui.change_line(speaker, line)
