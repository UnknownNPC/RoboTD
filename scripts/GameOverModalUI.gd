extends Control

var mainMenuScene = "res://scenes/MainMenu.tscn"

onready var MUSIC_SERVICE = $"/root/LevelMusicPlayer"


func _ready():
	MUSIC_SERVICE.makeLevelMusicQuiet()


func _exit_tree():
	MUSIC_SERVICE.makeLevelMusicLouder()


func _on_RestartBtn_pressed():
	$"/root/LevelMusicPlayer".playClickBtnSound()
	get_tree().paused = false
	queue_free()
	$"/root/ScreenUISingleton"._resetUi()
	get_tree().reload_current_scene()


func _on_MenuBtn_pressed():
	MUSIC_SERVICE.stopPlayingLevelMusic()
	$"/root/LevelMusicPlayer".playClickBtnSound()
	get_tree().paused = false
	queue_free()
	$"/root/ScreenUISingleton"._resetUi()
	get_tree().change_scene(mainMenuScene)
