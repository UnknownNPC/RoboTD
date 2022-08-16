extends Control

var advertMobInstance = null


func init(currentAdvertMobInstance):
	advertMobInstance = currentAdvertMobInstance


func _on_ResumtBtn_pressed():
	get_tree().paused = false
	queue_free()
	$"/root/ScreenUISingleton".showCurrentWaveModal()


func _on_AdvertBtn_pressed():
	if is_instance_valid(advertMobInstance):
		advertMobInstance.show_rewarded_video()
		get_tree().paused = false
		queue_free()
