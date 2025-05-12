@tool
class_name Marker
extends TextureRect


@export var color: Color:
	set(value):
		color = value
		if is_instance_valid(color_rect):
			color_rect.color = value

@onready var color_rect: ColorRect = $ColorRect


func _ready() -> void:
	color_rect.color = color
