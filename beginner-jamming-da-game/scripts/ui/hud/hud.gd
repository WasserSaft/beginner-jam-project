extends Control

@export var inventory: Inventory
@export var player: Node
@onready var inventory_container = $VBoxContainer
@onready var hp_container: HBoxContainer = $"hp container"
@onready var dialog_ui: Control = $DialogUI

const HEALTH_ICON = preload("res://scenes/ui/hud/health_icon.tscn")


func _ready() -> void:
	display_hp()
	await get_tree().process_frame
	update_inventory()
	dialog_ui.visible = false

func display_hp():
	for child in hp_container.get_children():
		child.queue_free()
	for i in player.stats.hp:
		var hp_icon = HEALTH_ICON.instantiate()
		hp_container.add_child(hp_icon)

func update_inventory():
	var slots = inventory_container.get_children()

	for i in range(slots.size()):
		var item = player.inventory.items[i]  
		var slot = slots[i]
		var texture = item.sprite if item != null else null

		var icon_node = slot.get_node("TextureRect")
		icon_node.texture = texture

func show_dialogue(speaker: String, line: String):
	dialog_ui.visible = true
	dialog_ui.change_line(speaker, line)
