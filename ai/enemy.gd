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


func _physics_process(_delta: float) -> void:
	match _mode:
		Modes.CHASE:
			pass
		Modes.PATROL:
			# Move to next patrol point if close enough to next patrol point
			if patrol_points[_next_patrol_point_index].global_position.distance_squared_to(global_position) < DISTANCE_SQUARED_TO_GOTTEN_PATROL_POINT:
				_next_patrol_point_index = (_next_patrol_point_index + 1) % patrol_points.size()
			
			steering = 0
			var colliding = false
			# Move away from wall
			if ray_1_close.is_colliding():
				steering += 1
				engine_force = -100
				colliding = true
			if ray_2_close.is_colliding():
				steering -= 1
				engine_force = -100
				colliding = true
			
			if not colliding:
				# Steer toward next patrol point
				_steer_toward(patrol_points[_next_patrol_point_index].global_position)
				
				if position.normalized().dot(to_local(patrol_points[_next_patrol_point_index].global_position).normalized()) > 0:
					engine_force = 100
				else:
					engine_force = -50
					steering = 1
			
			
			#
			#if get_tree().get_frame() % 60 == 0: print(collision_test)
			#match collision_test:
				#CollisionResponse.NONE:
					#if position.normalized().dot(to_local(patrol_points[_next_patrol_point_index].global_position).normalized()) > 0:
						#engine_force = 100
					#else:
						#engine_force = -50
						#steering = 1
				#CollisionResponse.BOTH:
					#engine_force = -100
				#CollisionResponse.CLOSE_LEFT:
					#steering = 1
					#engine_force = -100
				#CollisionResponse.CLOSE_RIGHT:
					#steering = -1
					#engine_force = -100
				#CollisionResponse.PLAYER:
					#engine_force = 150


func _steer_toward(global_pos: Vector3) -> void:
	var dot = position.normalized().dot(to_local(global_pos).rotated(Vector3.UP, PI / 2).normalized())
	steering = clampf(-1 * dot, -PI / 2, PI / 2)
