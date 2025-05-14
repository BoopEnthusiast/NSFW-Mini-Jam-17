class_name Person
extends RigidBody3D


enum Gender {
	MALE,
	FEMALE,
}

const GENDERS: Array[Gender] = [Gender.MALE, Gender.FEMALE]

var gender: Gender

@onready var masc_hey: FmodEventEmitter3D = $MascHey
@onready var fem_hey: FmodEventEmitter3D = $FemHey


func _ready() -> void:
	gender = GENDERS.pick_random()


func _physics_process(_delta: float) -> void:
	global_position.y = 0


func say_hey() -> void:
	match gender:
		Gender.MALE:
			masc_hey.play()
		Gender.FEMALE:
			fem_hey.play()
