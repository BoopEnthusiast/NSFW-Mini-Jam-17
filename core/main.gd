class_name Main
extends Node3D


const PERSON = preload("res://ai/person.tscn")
const HOTEL = preload("res://level/hotel.tscn")

const TIME_TO_SPAWN_MULTIPLYER = 8.0

@export var time_to_spawn: Curve

var time_left: float = 100.0

var _time_to_spawn_point: int = 0

@onready var person_spawners: Node3D = $PersonSpawners
@onready var spawn_timer: Timer = $SpawnTimer
@onready var hud_layer: CanvasLayer = $HUDLayer


func _enter_tree() -> void:
	Nodes.main = self


func _process(delta: float) -> void:
	time_left -= delta
	if time_left <= 0:
		StateManager.lose_the_game()


func _on_spawn_timer_timeout() -> void:
	# Spawn a new person along a random point along a random PersonSpawner
	var spawner = person_spawners.get_children().pick_random() as Path3D
	var point_to_spawn = spawner.curve.get_baked_points().get(randi_range(0, spawner.curve.get_baked_points().size() - 1)).rotated(Vector3.UP, spawner.rotation.y) + spawner.global_position
	var new_person = PERSON.instantiate()
	add_child(new_person)
	new_person.global_position = point_to_spawn
	
	spawn_timer.wait_time = (time_to_spawn.sample_baked(_time_to_spawn_point) + 1.0) * TIME_TO_SPAWN_MULTIPLYER
	_time_to_spawn_point += 1
	_time_to_spawn_point = clamp(_time_to_spawn_point, 0, time_to_spawn.bake_resolution)
	spawn_timer.start()


func spawn_hotel() -> void:
	# Spawn a hotel along a random point along a random PersonSpawner
	var spawner = person_spawners.get_children().pick_random() as Path3D
	var point_to_spawn = spawner.curve.get_baked_points().get(randi_range(0, spawner.curve.get_baked_points().size() - 1)).rotated(Vector3.UP, spawner.rotation.y) + spawner.global_position
	var new_hotel = HOTEL.instantiate()
	add_child(new_hotel)
	new_hotel.global_position = point_to_spawn
