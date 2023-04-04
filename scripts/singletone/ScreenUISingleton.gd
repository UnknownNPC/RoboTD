extends Node

const BaseTowerPreload = preload("res://scripts/BaseTower.gd")

var enemyInfoUrl = "res://scenes/UI/EnemyInfoUI.tscn"
var attackTowerInfoUrl = "res://scenes/UI/AttackTowerInfoUI.tscn"
var bufferTowerInfoUrl = "res://scenes/UI/BufferTowerInfoUI.tscn"
var debufferTowerInfoUrl = "res://scenes/UI/DebufferTowerInfoUI.tscn"

var towerInfoActionsUrl = "res://scenes/UI/TowerInfoActionsUI.tscn"

var towerBuyMenuUrl = "res://scenes/UI/BuyTowerMenu.tscn"
var waveBonusUrl = "res://scenes/UI/WaveBonusUI.tscn"
var firstWaveMessageModalUrl = "res://scenes/UI/FirstWaveMessageModal.tscn"
var pauseMenuModalUrl = "res://scenes/UI/PauseModalUI.tscn"
var showAdvertMenuModal = "res://scenes/UI/advert/ShowAdvertModalUI.tscn"
var gameOverModalUrl = "res://scenes/UI/GameOverModalUI.tscn"
var levelCompletedModalUrl = "res://scenes/UI/LevelCompletedModalUI.tscn"

var currentPanel
var currentAdditionalPanel
var currentWaveModal

var UIModalContainer = null

# all nodes = 0
# attack circle, select brakets, enemy healths, rocket, granade = 1
# base level UI, menu = 2
# all modals = 3


func _ready():
	UIModalContainer = CanvasLayer.new()
	UIModalContainer.layer = 3
	add_child(UIModalContainer)


### modals with pause mode
func showPauseModal():
	hideCurrentWaveModal()
	_showGamePauseModal(pauseMenuModalUrl)


func showLevelCompleteModal():
	_resetUi()
	_resetCurrentWaveModal()
	_showGamePauseModal(levelCompletedModalUrl)


func showGameOverModal():
	_resetUi()
	_resetCurrentWaveModal()
	_showGamePauseModal(gameOverModalUrl)


func _showGamePauseModal(gameModalUrl):
	get_tree().paused = true
	var sceneInstance = load(gameModalUrl).instance()
	UIModalContainer.add_child(sceneInstance)


func showAdvertModal(advertMob):
	hideCurrentWaveModal()
	get_tree().paused = true
	var advertModal = load(showAdvertMenuModal).instance()
	advertModal.init(advertMob)
	UIModalContainer.add_child(advertModal)


##### modal with pause mods

################### start wave modals


func showCurrentWaveModal():
	if is_instance_valid(currentWaveModal):
		currentWaveModal.show()


func hideCurrentWaveModal():
	if is_instance_valid(currentWaveModal):
		currentWaveModal.hide()


func _resetCurrentWaveModal():
	if is_instance_valid(currentWaveModal):
		currentWaveModal.queue_free()


#### dirty hack because call in the BaseLevel#_ready
func showFirstWaveMenu(nextWaveSeconds):
	_resetUi()
	var firstWaveMessageModal = load(firstWaveMessageModalUrl).instance()
	UIModalContainer.call_deferred("add_child", firstWaveMessageModal)
	firstWaveMessageModal.call_deferred("display", nextWaveSeconds)
	currentWaveModal = firstWaveMessageModal


func showLevelBonusMenu(energySize, nextWaveSeconds):
	var waveBonus = load(waveBonusUrl).instance()
	UIModalContainer.add_child(waveBonus)
	waveBonus.display(energySize, nextWaveSeconds)
	currentWaveModal = waveBonus


#################### end wave modals


func addBuyTowerMenuPanel():
	_removePanel(currentPanel)
	_removePanel(currentAdditionalPanel)
	var buyMenuUi = load(towerBuyMenuUrl).instance()
	UIModalContainer.add_child(buyMenuUi)
	currentPanel = buyMenuUi
	return buyMenuUi


func addInfoPanel(entity):
	_removePanel(currentPanel)
	_removePanel(currentAdditionalPanel)
	var isEnemy = entity.is_in_group("enemies")

	var url = null
	if isEnemy:
		url = enemyInfoUrl
	else:
		match entity.towerType:
			BaseTowerPreload.TowerType.Attack:
				url = attackTowerInfoUrl
			BaseTowerPreload.TowerType.Buffer:
				url = bufferTowerInfoUrl
			BaseTowerPreload.TowerType.Debuffer:
				url = debufferTowerInfoUrl
		currentAdditionalPanel = _addInfoUI(entity, towerInfoActionsUrl)

	currentPanel = _addInfoUI(entity, url)


func _unhandled_input(event):
	## reset all panels
	if event is InputEventMouseButton and event.is_pressed():
		_resetUi()


func _resetUi():
	_cleanupMouseSelection()
	_removePanel(currentPanel)
	_removePanel(currentAdditionalPanel)


func _cleanupMouseSelection():
	var allSelectable = get_tree().get_nodes_in_group("selectable")
	for selectable in allSelectable:
		if is_instance_valid(selectable.selectSprite):
			selectable.selectSprite.hide()
		if "radiusShape" in selectable:
			selectable.radiusShape.hide()


func _removePanel(panel):
	if is_instance_valid(panel):
		panel.queue_free()


func _addInfoUI(entity, sceneUrl):
	var infoIU = load(sceneUrl).instance()
	UIModalContainer.add_child(infoIU)
	infoIU.init(entity)
	return infoIU
