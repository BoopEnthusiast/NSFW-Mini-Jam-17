class_name Person
extends RigidBody3D


enum Gender {
	MALE,
	FEMALE,
}

const GENDERS: Array[Gender] = [Gender.MALE, Gender.FEMALE]

var gender: Gender
var has_found_direction: bool = false

@onready var masc_hey: FmodEventEmitter3D = $MascHey
@onready var fem_hey: FmodEventEmitter3D = $FemHey
@onready var masc_base_model: MascBaseModel = $"Masc Base Model"
@onready var fem_base_model: FemBaseModel = $"Fem Base Model"
@onready var raycasts: Array[RayCast3D] = [$RayCasts/Ray, $RayCasts/Ray2, $RayCasts/Ray3, $RayCasts/Ray4]


func _ready() -> void:
	gender = GENDERS.pick_random()
	match gender:
		Gender.MALE:
			masc_base_model.animation_player.play("Male Pose 1")
			masc_base_model.visible = true
		Gender.FEMALE:
			fem_base_model.animation_player.play("Fem Pose 1")
			fem_base_model.visible = true


func _physics_process(_delta: float) -> void:
	global_position.y = 0
	if not has_found_direction:
		has_found_direction = rotate_away_from_wall()


func say_hey() -> void:
	match gender:
		Gender.MALE:
			masc_hey.play()
		Gender.FEMALE:
			fem_hey.play()


func rotate_away_from_wall() -> bool:
	for ray: RayCast3D in raycasts:
		if ray.is_colliding():
			rotate(Vector3.UP, (-basis.z).angle_to(ray.target_position))
			return true
	return false
