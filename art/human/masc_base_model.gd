class_name MascBaseModel
extends Node3D


@export var nude: bool = false

var which_mesh: int = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var meshes = [$"Male Rig/Skeleton3D/Masc 1", $"Male Rig/Skeleton3D/Masc 2", $"Male Rig/Skeleton3D/Masc 3"]
var nude_meshes = [$"Male Rig/Skeleton3D/Masc 1 Nude", $"Male Rig/Skeleton3D/Masc 2 Nude", $"Male Rig/Skeleton3D/Masc 3 Nude"]


func _ready() -> void:
	which_mesh = randi_range(0, 2)
	
	for mesh in meshes:
		mesh.visible = false
	for mesh in nude_meshes:
		mesh.visible = false
	
	if nude:
		nude_meshes[which_mesh].visible = true
	else:
		meshes[which_mesh].visible = true
