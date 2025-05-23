class_name Minimap
extends TextureRect


const MAP_SCALE = 2.0

const MARKER = preload("res://gui/marker.tscn")

@onready var minimap_camera: Camera3D = $SubViewportContainer/SubViewport/MinimapCamera


func _process(_delta: float) -> void:
	minimap_camera.scale = Vector3(MAP_SCALE, MAP_SCALE, MAP_SCALE)
	
	# Child going through right now
	var i: int = 1
	
	# Player
	var player_child: Marker = get_child(i) if get_child_count() > i else null
	# Make new marker if there is none 
	if not is_instance_valid(player_child):
		player_child = make_new_marker()
	player_child.color = Color.GREEN
	var position_to_player = Nodes.player.to_local(Nodes.player.global_position).rotated(Vector3.UP, PI / 2) / MAP_SCALE
	player_child.position = Vector2(position_to_player.x, position_to_player.z) + size / 2
	i += 1
	
	# Enemies
	for enemy: Enemy in get_tree().get_nodes_in_group("enemy"):
		var enemy_child: Marker = get_child(i) if get_child_count() > i else null
		# Make new marker if there is none
		if not is_instance_valid(enemy_child):
			enemy_child = make_new_marker()
		enemy_child.color = Color.RED
		position_to_player = Nodes.player.to_local(enemy.global_position).rotated(Vector3.UP, PI / 2) / MAP_SCALE
		enemy_child.position = Vector2(position_to_player.x, position_to_player.z) + size / 2
		i += 1
	
	# People
	for person: Person in get_tree().get_nodes_in_group("person"):
		var person_child: Marker = get_child(i) if get_child_count() > i else null
		# Make new marker if there is none
		if not is_instance_valid(person_child):
			person_child = make_new_marker()
		match person.gender:
			Person.Gender.MALE:
				person_child.color = Color.BLUE
			Person.Gender.FEMALE:
				person_child.color = Color.MAGENTA
		position_to_player = Nodes.player.to_local(person.global_position).rotated(Vector3.UP, PI / 2) / MAP_SCALE
		person_child.position = Vector2(position_to_player.x, position_to_player.z) + size / 2
		i += 1
	
	# Hotels
	for hotel: Hotel in get_tree().get_nodes_in_group("hotel"):
		var hostel_child: Marker = get_child(i) if get_child_count() > i else null
		# Make new marker if there is none 
		if not is_instance_valid(hostel_child):
			hostel_child = make_new_marker()
		hostel_child.color = Color.YELLOW
		position_to_player = Nodes.player.to_local(hotel.global_position).rotated(Vector3.UP, PI / 2) / MAP_SCALE
		hostel_child.position = Vector2(position_to_player.x, position_to_player.z) + size / 2
		i += 1
	
	while get_child_count() > i:
		remove_child(get_child(i))


func make_new_marker() -> Marker:
	var new_marker = MARKER.instantiate()
	add_child(new_marker)
	return new_marker
