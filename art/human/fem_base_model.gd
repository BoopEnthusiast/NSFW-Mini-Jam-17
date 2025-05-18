class_name FemBaseModel
extends Node3D


@export var which_mesh: int = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var meshes = [$"Fem Rig/Skeleton3D/Fem 1", $"Fem Rig/Skeleton3D/Fem 1 Nude"]


func _ready() -> void:
	for i in range(meshes.size()):
		if i == which_mesh:
			meshes[i].visible = true
		else:
			meshes[i].visible = false
