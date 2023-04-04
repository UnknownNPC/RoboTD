extends CanvasLayer

onready var levelBtnExample = $UI/SelectLevel/LevelsContainer/GridContainer/ButtonExample
onready var levelBtnsGrid = $UI/SelectLevel/LevelsContainer/GridContainer

onready var gameMainMenu = $UI/GameMainMenu
onready var selectLevel = $UI/SelectLevel
onready var credentials = $UI/Credentials
onready var settings = $UI/Settings

onready var LEVEL_MANAGER = $"/root/LevelManager"
onready var SAVE_GAME_SERVICE = $"/root/GameSaveService"
onready var MUSIC_PLAYER = $"/root/LevelMusicPlayer"

#settings
onready var isMusicOnToogle = $UI/Settings/HBoxContainer/MusicSwitcher as CheckButton
onready var isSfxOnToogle = $UI/Settings/HBoxContainer/SfxSwitcher as CheckButton


func _ready():
	MUSIC_PLAYER.playMenuMusic()

	var lastCompletedLevel = SAVE_GAME_SERVICE.loadLastLevel()
	for levelId in LEVEL_MANAGER.getLevels():
		var selectLevelBtn = levelBtnExample.duplicate()
		## open next
		if levelId > lastCompletedLevel + 1:
			selectLevelBtn.disabled = true
		selectLevelBtn.show()
		selectLevelBtn.text = LevelManager.getLevelNameById(levelId)
		selectLevelBtn.connect("pressed", self, "_levelBtnClicked", [levelId])
		levelBtnsGrid.add_child(selectLevelBtn)

	var isBgmOn = SAVE_GAME_SERVICE.isMusicOn()
	var isSfxOn = SAVE_GAME_SERVICE.isSfxOn()
	isMusicOnToogle.set_pressed_no_signal(isBgmOn)
	isSfxOnToogle.set_pressed_no_signal(isSfxOn)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("bgm"), !isBgmOn)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), !isSfxOn)


func _levelBtnClicked(levelId):
	MUSIC_PLAYER.playClickBtnSound()
	MUSIC_PLAYER.stopMenuMusic()
	LEVEL_MANAGER.loadLevelById(levelId)


func _on_CampainBtn_pressed():
	MUSIC_PLAYER.playClickBtnSound()
	gameMainMenu.hide()
	selectLevel.show()


func _on_GoBackBtn_pressed():
	MUSIC_PLAYER.playClickBtnSound()
	# go back from campain or crendetials page
	selectLevel.hide()
	credentials.hide()
	settings.hide()
	gameMainMenu.show()


func _on_CredentialBtn_pressed():
	MUSIC_PLAYER.playClickBtnSound()
	gameMainMenu.hide()
	credentials.show()


func _on_SettingsBtn_pressed():
	MUSIC_PLAYER.playClickBtnSound()
	gameMainMenu.hide()
	settings.show()


func _on_MusicSwitcher_toggled(isOn):
	MUSIC_PLAYER.playClickBtnSound()
	SAVE_GAME_SERVICE.setMusicOn(isOn)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("bgm"), !isOn)


func _on_SfxSwitcher_toggled(isOn):
	MUSIC_PLAYER.playClickBtnSound()
	SAVE_GAME_SERVICE.setSfxOn(isOn)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), !isOn)
