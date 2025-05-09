class_name MainMenu
extends Control


signal play_game()


func _on_play_pressed() -> void:
	play_game.emit()
