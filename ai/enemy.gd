class_name Enemy
extends VehicleBody3D


enum Modes {
	CHASE,
	PATROL,
}

@onready var collision_test: Node3D = $CollisionTest
@onready var collision_test_rays: Array = collision_test.get_children()
