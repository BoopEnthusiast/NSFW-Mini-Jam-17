class_name Enemy
extends VehicleBody3D


enum Modes {
	CHASE,
	PATROL,
}
enum CollisionResponse {
	CLOSE_LEFT,
	CLOSE_RIGHT,
	FAR_LEFT,
	FAR_RIGHT,
	CLOSE_BOTH,
	FAR_BOTH,
	NONE,
	PLAYER,
}

const DISTANCE_SQUARED_TO_GOTTEN_PATROL_POINT = 300

@export var patrol_points: Array[Marker3D]

var _mode: Modes = Modes.PATROL
var _next_patrol_point_index: int = 0

@onready var ray_1_close: RayCast3D = $CollisionTestClose/Ray1
@onready var ray_2_close: RayCast3D = $CollisionTestClose/Ray2
@onready var ray_1_far: RayCast3D = $CollisionTestFar/Ray1
@onready var ray_2_far: RayCast3D = $CollisionTestFar/Ray2
@onready var center_ray: RayCast3D = $CollisionTestClose/CenterRay

@onready var debug: Node3D = $Debug
@onready var debug_2: Node3D = $Debug2
@onready var debug_goal_mesh: MeshInstance3D = $DebugGoalMesh


func _physics_process(_delta: float) -> void:
	match _mode:
		Modes.CHASE:
			pass
		Modes.PATROL:
			# Move to next patrol point if close enough to next patrol point
			if patrol_points[_next_patrol_point_index].global_position.distance_squared_to(global_position) < DISTANCE_SQUARED_TO_GOTTEN_PATROL_POINT:
				_next_patrol_point_index = (_next_patrol_point_index + 1) % patrol_points.size()
			
			# Steer toward next patrol point
			_steer_toward(patrol_points[_next_patrol_point_index].global_position)
			
			debug_goal_mesh.global_position = patrol_points[_next_patrol_point_index].global_position
			
			debug_2.rotation.y = steering
			
			var target_direction = (patrol_points[_next_patrol_point_index].global_position - global_position)
			var angle_to_target = (-global_basis.z).angle_to(target_direction.rotated(Vector3.UP, PI / 2))
			
			# Drive toward patrol point, else try turning around towards it
			if angle_to_target < PI * 0.2:
				engine_force = 100
			else:
				engine_force = -50
				steering = 1
			
			# Steer away from far away walls
			if ray_1_far.is_colliding():
				steering += PI / 2
			if ray_2_far.is_colliding():
				steering += -PI / 2
			
			
			# Move away from close up walls
			if ray_1_close.is_colliding():
				steering = 1
				engine_force = -100
			if ray_2_close.is_colliding():
				steering = -1
				engine_force = -100
			
			if center_ray.is_colliding():
				steering = 0
				engine_force = -300
			
			debug.rotation.y = steering


func _steer_toward(global_pos: Vector3) -> void:
	var current_direction = -global_transform.basis.z
	var to_target = global_pos - global_position
	to_target.y = 0
	var target_direction = to_target.normalized()
	var angle_to_target = current_direction.signed_angle_to(target_direction, Vector3.UP)
	steering = angle_to_target + PI / 2
