class_name Person
extends StaticBody3D


enum Gender {
	MALE,
	FEMALE,
}

const GENDERS: Array[Gender] = [Gender.MALE, Gender.FEMALE]

var gender: Gender


func _ready() -> void:
	gender = GENDERS.pick_random()
