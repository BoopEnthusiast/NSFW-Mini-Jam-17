class_name Player
extends VehicleBody3D


const ENGINE_FORCE = 300
const BRAKE_FORCE = 100
const TURN_MULTIPLYER = 0.15

const SECONDS_TO_GET_HOTEL = 3

var reversing: bool = false
var collected_people: Array[Person.Gender] = []

var hotel_inside: Hotel

var is_colliding: bool = false

var couples_assisted: int = 0

@onready var camera: Camera3D = $Camera
@onready var camera_animator: AnimationPlayer = $CameraAnimator

@onready var bump_animator: AnimationPlayer = $BumpAnimator
@onready var collect_area: Area3D = $CollectArea

@onready var masc_greeting: FmodEventEmitter3D = $MascGreeting
@onready var fem_greeting: FmodEventEmitter3D = $FemGreeting
@onready var bumpin: FmodEventEmitter3D = $Bumpin
@onready var bump_masc: FmodEventEmitter3D = $BumpMasc
@onready var bump_fem: FmodEventEmitter3D = $BumpFem
@onready var drop_off_success: FmodEventEmitter3D = $DropOffSuccess

@onready var sitting_fem: FemBaseModel = $"Cat Car2/Cat Car Game Obj Origin/Car Body Origin/Passenger Seat 1 Pos/SittingFem"
@onready var sitting_masc: MascBaseModel = $"Cat Car2/Cat Car Game Obj Origin/Car Body Origin/Passenger Seat 2 Pos/SittingMasc"

@onready var fucking_fem_2: FemBaseModel = $"Cat Car2/Cat Car Game Obj Origin/Car Body Origin/Passenger Sex Pos/FuckingFem2"
@onready var fucking_fem: FemBaseModel = $"Cat Car2/Cat Car Game Obj Origin/Car Body Origin/Passenger Sex Pos/FuckingFem"
@onready var fucking_masc: MascBaseModel = $"Cat Car2/Cat Car Game Obj Origin/Car Body Origin/Passenger Sex Pos/FuckingMasc"
@onready var fucking_masc_2: MascBaseModel = $"Cat Car2/Cat Car Game Obj Origin/Car Body Origin/Passenger Sex Pos/FuckingMasc2"

@onready var car_back_half_hideable: MeshInstance3D = $"Cat Car2/Cat Car Game Obj Origin/Car Body Origin/Car Back Half (Hideable)"

@onready var hotel_bar: Sprite3D = $HotelBar
@onready var hotel_progress_bar: ProgressBar = $SubViewport/HotelBar

@onready var collision_rays: Array[RayCast3D] = [$CollisionRays/Ray, $CollisionRays/Ray2, $CollisionRays/Ray3, $CollisionRays/Ray4]

@onready var arrow: CSGPolygon3D = $Arrow


func _enter_tree() -> void:
	Nodes.player = self


func _ready() -> void:
	hotel_progress_bar.max_value = SECONDS_TO_GET_HOTEL


func _physics_process(_delta: float) -> void:
	# Stop reversing if moving forward
	if Input.is_action_pressed("forward"):
		reversing = false
	
	# Calculate engine force and steering
	engine_force = ENGINE_FORCE * Input.get_action_strength("forward")
	steering = Input.get_axis("right", "left") * TURN_MULTIPLYER
	
	# If stopped moving and trying to reverse, start reversing
	if linear_velocity.length_squared() < 25 and Input.is_action_pressed("backward"):
		reversing = true
	
	# If not reversing, brake
	if not reversing:
		brake = BRAKE_FORCE * Input.get_action_strength("backward")
	else:
		brake = 0
	
	# If reversing, move backward
	if reversing:
		engine_force = -ENGINE_FORCE * Input.get_action_strength("backward")
	
	# Flip back over
	if rotation.z > PI / 2 or rotation.z < -PI / 2:
		rotation.z = 0
	
	# Fmod events
	$speed_emitter.set_parameter("speed", linear_velocity.length())
	#print(linear_velocity.length())
	#engine_force_emitter.set_parameter("engine_force", engine_force)
	
	if Input.is_action_just_pressed("bump"):
		if not bump_animator.is_playing():
			Nodes.cum_bar.value += 10.0
			bumpin.play_one_shot()
			for person: Person.Gender in collected_people:
				match person:
					Person.Gender.MALE:
						bump_masc.play_one_shot()
					Person.Gender.FEMALE:
						bump_fem.play_one_shot()
		bump_animator.play("bump")
	
	# Collect people
	if Input.is_action_just_pressed("collect"):
		# Collect the person
		for body in collect_area.get_overlapping_bodies():
			if body is Person and collected_people.size() < 2:
				collected_people.append(body.gender)
				body.queue_free()
				
				# Make them sit if there's one collected person
				if collected_people.size() == 1:
					match body.gender:
						Person.Gender.MALE:
							sitting_masc.visible = true
							sitting_masc.animation_player.play("M Sit")
						Person.Gender.FEMALE:
							sitting_fem.visible = true
							sitting_fem.animation_player.play("F Sit")
				# Make them fuck if there's two collected people
				else:
					car_back_half_hideable.visible = false
					sitting_fem.visible = false
					sitting_masc.visible = false
					Nodes.main.spawn_hotel()
					Nodes.cum_bar.visible = true
					Nodes.cum_bar.value = 0.0
					if collected_people[0] == Person.Gender.MALE and collected_people[1] == Person.Gender.MALE:
						fucking_masc.visible = true
						fucking_masc.animation_player.play("MM TOP")
						fucking_masc_2.visible = true
						fucking_masc_2.animation_player.play("MM BOT")
					elif (collected_people[0] == Person.Gender.MALE and collected_people[1] == Person.Gender.FEMALE) or (collected_people[1] == Person.Gender.MALE and collected_people[0] == Person.Gender.FEMALE):
						fucking_masc.visible = true
						fucking_masc.animation_player.play("MF TOP")
						fucking_fem.visible = true
						fucking_fem.animation_player.play("MF BOT")
					else:
						fucking_fem.visible = true
						fucking_fem.animation_player.play("FF TOP")
						fucking_fem_2.visible = true
						fucking_fem_2.animation_player.play("FF BOT")
	
	var found_collision := false
	for ray: RayCast3D in collision_rays:
		if ray.is_colliding():
			found_collision = true
			if not is_colliding:
				is_colliding = true
				Nodes.cum_bar.value -= 5.0
				break
	if not found_collision:
		is_colliding = false


func _process(delta: float) -> void:
	var i = 0
	for hotel: Hotel in get_tree().get_nodes_in_group("hotel"):
		arrow.visible = true
		arrow.look_at(hotel.global_position)
		arrow.rotate(Vector3.UP, -PI / 2)
		i += 1
	if i == 0:
		arrow.visible = false
	
	if hotel_bar.visible:
		hotel_progress_bar.value += delta
		if hotel_progress_bar.value >= hotel_progress_bar.max_value:
			hotel_inside.queue_free()
			fucking_masc.visible = false
			fucking_masc.animation_player.stop()
			fucking_masc_2.visible = false
			fucking_masc_2.animation_player.stop()
			fucking_fem.visible = false
			fucking_fem.animation_player.stop()
			fucking_fem_2.visible = false
			fucking_fem_2.animation_player.stop()
			car_back_half_hideable.visible = true
			hotel_bar.visible = false
			collected_people.clear()
			Nodes.main.time_left += Nodes.cum_bar.value + 10.0
			Nodes.cum_bar.visible = false
			drop_off_success.play_one_shot()
			couples_assisted += 1
	else:
		hotel_progress_bar.value = 0.0


func _on_collect_area_body_entered(body: Node3D) -> void:
	if body is Person:
		if collected_people.size() < 2:
			match body.gender:
				Person.Gender.MALE:
					masc_greeting.play()
				Person.Gender.FEMALE:
					fem_greeting.play()


func _on_hey_area_body_entered(body: Node3D) -> void:
	if body is Person:
		if collected_people.size() < 2:
			body.say_hey()


func entered_hotel(hotel: Hotel) -> void:
	hotel_bar.visible = true
	hotel_inside = hotel


func exited_hotel(hotel: Hotel) -> void:
	hotel_bar.visible = false
	hotel_inside = hotel
