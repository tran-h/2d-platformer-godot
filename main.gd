extends Node2D

func _ready() -> void:
	Utils.loadGame()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	if Game.playerHP < 0:
		Utils.resetGame()
	get_tree().change_scene_to_file("res://world.tscn")
