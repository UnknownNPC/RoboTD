extends Control

var advertMobInstance = null

onready var resumePauseSoundPlayer = $ResumePauseSoundPlayer as AudioStreamPlayer
onready var MUSIC_SERVICE = $"/root/LevelMusicPlayer"


func _ready():
	MUSIC_SERVICE.makeLevelMusicQuiet()


func _exit_tree():
	MUSIC_SERVICE.makeLevelMusicLouder()


func init(currentAdvertMobInstance):
	advertMobInstance = currentAdvertMobInstance


func _on_ResumtBtn_pressed():
	resumePauseSoundPlayer.play()
	yield(resumePauseSoundPlayer, "finished")
	get_tree().paused = false
	queue_free()
	$"/root/ScreenUISingleton".showCurrentWaveModal()


func _on_AdvertBtn_pressed():
	$"/root/LevelMusicPlayer".playClickBtnSound()
	if is_instance_valid(advertMobInstance):
		advertMobInstance.show_rewarded_video()
		get_tree().paused = false
		queue_free()
