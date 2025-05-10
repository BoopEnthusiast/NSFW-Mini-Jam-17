class_name GameManager
extends Node


@onready var main: Main = $Main
@onready var main_menu: MainMenu = $WhenPausedLayer/MainMenu


func _ready() -> void:
	get_tree().paused = true


func _on_main_menu_play_game() -> void:
	main.visible = true
	main_menu.visible = false
	get_tree().paused = false
