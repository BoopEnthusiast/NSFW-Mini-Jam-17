class_name Main
extends Node3D


const PERSON = preload("res://ai/person.tscn")

@export var time_to_spawn: Curve

var _time_to_spawn_point: int = 0

@onready var person_spawners: Node3D = $PersonSpawners
@onready var spawn_timer: Timer = $SpawnTimer


func _on_spawn_timer_timeout() -> void:
	var spawner = person_spawners.get_children().pick_random() as Path3D
	var point_to_spawn = spawner.curve.get_baked_points().get(randi_range(0, spawner.curve.get_baked_points().size() - 1)) + spawner.global_position
	var new_person = PERSON.instantiate()
	new_person.global_position = point_to_spawn
	print(point_to_spawn)
	add_child(new_person)
	
	spawn_timer.wait_time = time_to_spawn.sample_baked(_time_to_spawn_point) * 10
	_time_to_spawn_point += 1
	_time_to_spawn_point = clamp(_time_to_spawn_point, 0, time_to_spawn.bake_resolution)
