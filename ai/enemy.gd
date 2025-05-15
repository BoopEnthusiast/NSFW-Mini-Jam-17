class_name Enemy
extends VehicleBody3D


enum Modes {
	CHASE,
	PATROL,
}

const DISTANCE_SQUARED_TO_GOTTEN_PATROL_POINT = 300.0
const SECONDS_TO_CATCH_PLAYER = 3.0
const TIME_TO_STOP_CHASING = 0.5

@export var patrol_points: Array[Marker3D]

var _mode: Modes
var _next_patrol_point_index: int = 0
var _caught_player_progress: float = 0.0
var _previous_location: Vector3
var _reset_location: Vector3

@onready var ray_1_close: RayCast3D = $CollisionTestClose/Ray1
@onready var ray_2_close: RayCast3D = $CollisionTestClose/Ray2
@onready var ray_1_far: RayCast3D = $CollisionTestFar/Ray1
@onready var ray_2_far: RayCast3D = $CollisionTestFar/Ray2
@onready var center_ray: RayCast3D = $CollisionTestClose/CenterRay

@onready var vision_bar: ProgressBar = $SubViewport/VisionBar
@onready var vision_cone: Area3D = $VisionCone

@onready var brake_timer: Timer = $Brake

@onready var cop_siren: FmodEventEmitter3D = $CopSiren


func _ready() -> void:
	_reset_location = global_position
	_previous_location = global_position
	vision_bar.max_value = SECONDS_TO_CATCH_PLAYER


func _physics_process(delta: float) -> void:
	# Check if seeing player
	var is_seeing_player: bool = false
	for node in vision_cone.get_overlapping_bodies():
		if node is Player:
			is_seeing_player = true
			break
	
	if is_seeing_player:
		if _mode == Modes.PATROL:
			cop_siren.set_parameter("copAlerted", true)
			cop_siren.play()
		_mode = Modes.CHASE
		_caught_player_progress += delta
		vision_bar.value = _caught_player_progress
	else:
		_caught_player_progress -= delta
		vision_bar.value = _caught_player_progress
		if _caught_player_progress < TIME_TO_STOP_CHASING:
			if _mode == Modes.CHASE:
				cop_siren.set_parameter("copAlerted", false)
				cop_siren.play()
			_mode = Modes.PATROL
	
	if _caught_player_progress >= SECONDS_TO_CATCH_PLAYER:
		StateManager.lose_the_game()
	
	_caught_player_progress = clampf(_caught_player_progress, 0.0, SECONDS_TO_CATCH_PLAYER)
	
	match _mode:
		Modes.CHASE:
			engine_force = 150
			_steer_toward(Nodes.player.global_position)
			
		Modes.PATROL:
			# Move to next patrol point if close enough to next patrol point
			if patrol_points[_next_patrol_point_index].global_position.distance_squared_to(global_position) < DISTANCE_SQUARED_TO_GOTTEN_PATROL_POINT:
				_next_patrol_point_index = (_next_patrol_point_index + 1) % patrol_points.size()
				_brake()
			
			# Steer toward next patrol point
			_steer_toward(patrol_points[_next_patrol_point_index].global_position)
			
			var target_direction = (patrol_points[_next_patrol_point_index].global_position - global_position)
			var angle_to_target = (-global_basis.z).angle_to(target_direction.rotated(Vector3.UP, PI / 2))
			
			# Drive toward patrol point, else try turning around towards it
			if angle_to_target < PI * 0.5:
				engine_force = 75
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
			
			# Move away if too close to corner
			if center_ray.is_colliding():
				steering = 0
				engine_force = -300


func _steer_toward(global_pos: Vector3) -> void:
	var current_direction = -global_transform.basis.z
	var to_target = global_pos - global_position
	to_target.y = 0
	var target_direction = to_target.normalized()
	var angle_to_target = current_direction.signed_angle_to(target_direction, Vector3.UP)
	steering = angle_to_target + PI / 2


func _on_reset_timer_timeout() -> void:
	if global_position.distance_to(_previous_location) < 10:
		_reset_position()
	_previous_location = global_position


func _reset_position() -> void:
	global_position = _reset_location


func _brake() -> void:
	brake_timer.start()
	brake = 1000
	engine_force = -500


func _on_brake_timeout() -> void:
	brake = 0
