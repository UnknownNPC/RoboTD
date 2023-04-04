extends Control

onready var pauseInSoundPlayer = $PauseInSoundPlayer as AudioStreamPlayer


func _on_HomeBtn_pressed():
	pauseInSoundPlayer.play()
	yield(pauseInSoundPlayer, "finished")
	$"/root/ScreenUISingleton".showPauseModal()
