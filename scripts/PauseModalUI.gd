extends Control

var mainMenuScene = "res://scenes/MainMenu.tscn"


func _on_ResumtBtn_pressed():
	get_tree().paused = false
	queue_free()
	$"/root/ScreenUISingleton".showCurrentWaveModal()


func _on_RestartBtn_pressed():
	get_tree().paused = false
	queue_free()
	$"/root/ScreenUISingleton"._resetCurrentWaveModal()
	get_tree().reload_current_scene()


func _on_Menu_pressed():
	get_tree().paused = false
	queue_free()
	$"/root/ScreenUISingleton"._resetCurrentWaveModal()
	get_tree().change_scene(mainMenuScene)
