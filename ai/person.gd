class_name Person
extends RigidBody3D


enum Gender {
	MALE,
	FEMALE,
}

const GENDERS: Array[Gender] = [Gender.MALE, Gender.FEMALE]

var gender: Gender


func _ready() -> void:
	gender = GENDERS.pick_random()


func _physics_process(_delta: float) -> void:
	global_position.y = 0
