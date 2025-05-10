class_name Enemy
extends VehicleBody3D


enum Modes {
	CHASE,
	PATROL,
}
enum CollisionResponse {
	LEFT,
	RIGHT,
	BOTH,
	NONE,
	PLAYER
}

const DISTANCE_SQUARED_TO_GOTTEN_PATROL_POINT = 300

@export var patrol_points: Array[Marker3D]

var _mode: Modes = Modes.PATROL
var _next_patrol_point_index: int = 0

@onready var ray_1: RayCast3D = $CollisionTest/Ray1
@onready var ray_2: RayCast3D = $CollisionTest/Ray2


func _physics_process(_delta: float) -> void:
	match _mode:
		Modes.CHASE:
			pass
		Modes.PATROL:
			# Move to next patrol point if close enough to next patrol point
			if patrol_points[_next_patrol_point_index].global_position.distance_squared_to(global_position) < DISTANCE_SQUARED_TO_GOTTEN_PATROL_POINT:
				_next_patrol_point_index = (_next_patrol_point_index + 1) % patrol_points.size()
			if get_tree().get_frame() % 60 == 0: 
				print(patrol_points[_next_patrol_point_index].global_position)
			_steer_toward(patrol_points[_next_patrol_point_index].global_position)
			
			var collision_test = _test_collision()
			match collision_test:
				CollisionResponse.NONE:
					if position.normalized().dot(to_local(patrol_points[_next_patrol_point_index].global_position).normalized()) > 0:
						engine_force = 100
					else:
						engine_force = -50
						steering = 1
				CollisionResponse.BOTH:
					engine_force = -100
				CollisionResponse.LEFT:
					steering = 1
				CollisionResponse.RIGHT:
					steering = -1
				CollisionResponse.PLAYER:
					engine_force = 150
			
			if get_tree().get_frame() % 60 == 0: print(engine_force)


func _steer_toward(global_pos: Vector3) -> void:
	var dot = position.normalized().dot(to_local(global_pos).rotated(Vector3.UP, PI / 2).normalized())
	steering = clampf(-1 * dot, -PI, PI)


func _test_collision() -> CollisionResponse:
	if ray_1.get_collider() is Player or ray_2.get_collider() is Player:
		return CollisionResponse.PLAYER
	
	var ray_1_collision: bool = ray_1.is_colliding()
	var ray_2_collision: bool = ray_2.is_colliding()
	
	if not ray_1_collision and not ray_2_collision:
		return CollisionResponse.NONE
	elif ray_1_collision and ray_2_collision:
		return CollisionResponse.BOTH
	elif ray_1_collision and not ray_2_collision:
		return CollisionResponse.LEFT
	elif not ray_1_collision and ray_2_collision:
		return CollisionResponse.RIGHT
	return CollisionResponse.NONE
