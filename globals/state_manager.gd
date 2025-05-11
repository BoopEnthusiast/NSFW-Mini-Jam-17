extends Node


signal lose_game()


func lose_the_game():
	lose_game.emit()
