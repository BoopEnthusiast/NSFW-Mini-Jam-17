class_name Player
extends VehicleBody3D


const ENGINE_FORCE = 300
const BRAKE_FORCE = 100

@export var enemy: Enemy

var reversing: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var collected_people: Array[Person.Gender] = []


func _enter_tree() -> void:
	Nodes.player = self


func _physics_process(_delta: float) -> void:
	# Stop reversing if moving forward
	if Input.is_action_pressed("forward"):
		reversing = false
	
	# Calculate engine force and steering
	engine_force = ENGINE_FORCE * Input.get_action_strength("forward")
	steering = Input.get_axis("right", "left")
	
	# If not reversing, brake
	if not reversing:
		brake = BRAKE_FORCE * Input.get_action_strength("backward")
	else:
		brake = 0
	
	# If stopped moving and trying to reverse, start reversing
	if linear_velocity.length_squared() < 0.01 and Input.is_action_pressed("backward"):
		reversing = true
	
	
	# If reversing, move backward
	if reversing:
		engine_force = -ENGINE_FORCE * Input.get_action_strength("backward")
	
	# Flip back over
	if rotation.z > PI / 2 or rotation.z < -PI / 2:
		rotation.z = 0


func _on_collect_area_body_entered(body: Node3D) -> void:
	if body is Person:
		if collected_people.size() < 2:
			collected_people.append(body.gender)
			body.queue_free()
