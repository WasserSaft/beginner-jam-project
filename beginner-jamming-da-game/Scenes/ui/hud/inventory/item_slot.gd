extends Control

#ui node for 1 item icon
@onready var texture_rect: TextureRect = $TextureRect


func set_icon(texture: Texture):
	if texture_rect:
		texture_rect.texture = texture
