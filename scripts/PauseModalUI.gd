extends Control

var mainMenuScene = "res://scenes/MainMenu.tscn"


func _on_ResumtBtn_pressed():
	queue_free()
	get_tree().paused = false


func _on_RestartBtn_pressed():
	get_tree().paused = false
	pass  # Replace with function body.


func _on_Menu_pressed():
	get_tree().paused = false
	get_tree().change_scene(mainMenuScene)
