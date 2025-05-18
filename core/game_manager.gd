class_name GameManager
extends Node


@onready var main: Main = $Main
@onready var main_menu: MainMenu = $WhenPausedLayer/MainMenu
@onready var bgm: FmodEventEmitter3D = $FmodBankLoader/bgm


func _ready() -> void:
	Nodes.player.camera_animator.play("swing_to_behind")
	get_tree().paused = true


func _process(delta: float) -> void:
	if Nodes.main.time_left <= 30.0:
		bgm.set_parameter("bgmIntensity", "levelLate")
	elif Nodes.main.time_left <= 70.0:
		bgm.set_parameter("bgmIntensity", "levelEarly")


func _on_main_menu_play_game() -> void:
	main.visible = true
	main_menu.visible = false
	get_tree().paused = false
