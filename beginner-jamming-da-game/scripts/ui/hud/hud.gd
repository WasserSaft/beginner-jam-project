extends Control
@export var player: Node
@onready var hp_container: HBoxContainer = $"hp container"
const HEALTH_ICON = preload("res://scenes/ui/hud/health_icon.tscn")

func _ready() -> void:
	display_hp()

func display_hp():
	for child in hp_container.get_children():
		child.queue_free()
	for i in player.stats.hp:
		var hp_icon= HEALTH_ICON.instantiate()
		hp_container.add_child(hp_icon)
