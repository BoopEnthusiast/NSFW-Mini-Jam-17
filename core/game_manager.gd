class_name GameManager
extends Node


@onready var main: Main = $Main
@onready var main_menu: MainMenu = $CanvasLayer/MainMenu


func _on_main_menu_play_game() -> void:
	main.visible = true
	main_menu.visible = false
