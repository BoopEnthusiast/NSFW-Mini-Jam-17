class_name GameManager
extends Node


@onready var main: Main = $Main
@onready var main_menu: MainMenu = $WhenPausedLayer/MainMenu
@onready var bgm: FmodEventEmitter3D = $FmodBankLoader/bgm

@onready var total_time_label: Label = $WhenPausedLayer/LoseScreen/TotalTimeLabel
@onready var couples_assisted_label: Label = $WhenPausedLayer/LoseScreen/CouplesAssistedLabel
@onready var total_fine_label: Label = $WhenPausedLayer/LoseScreen/TotalFineLabel
@onready var lose_screen: Control = $WhenPausedLayer/LoseScreen


func _ready() -> void:
	Nodes.player.camera_animator.play("swing_to_behind")
	StateManager.lose_game.connect(_on_lose_game)
	get_tree().paused = true


func _process(_delta: float) -> void:
	if Nodes.main.time_left <= 30.0:
		bgm.set_parameter("bgmIntensity", "levelLate")
	elif Nodes.main.time_left <= 70.0:
		bgm.set_parameter("bgmIntensity", "levelEarly")


func _on_main_menu_play_game() -> void:
	main.visible = true
	main_menu.visible = false
	get_tree().paused = false


func _on_lose_game() -> void:
	get_tree().paused = true
	lose_screen.visible = true
	total_time_label.text = str(int(main.total_time))
	couples_assisted_label.text = str(Nodes.player.couples_assisted)
	total_fine_label.text = str(int(main.total_time) * Nodes.player.couples_assisted)
