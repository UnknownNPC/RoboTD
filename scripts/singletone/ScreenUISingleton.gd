extends Node

const BaseTowerPreload = preload("res://scripts/BaseTower.gd")

var enemyInfoUrl = "res://scenes/UI/EnemyInfoUI.tscn"
var attackTowerInfoUrl = "res://scenes/UI/AttackTowerInfoUI.tscn"
var bufferTowerInfoUrl = "res://scenes/UI/BufferTowerInfoUI.tscn"
var debufferTowerInfoUrl = "res://scenes/UI/DebufferTowerInfoUI.tscn"

var towerBuyMenuUrl = "res://scenes/UI/BuyTowerMenu.tscn"
var waveBonusUrl = "res://scenes/UI/WaveBonusUI.tscn"
var firstWaveMessageModalUrl = "res://scenes/UI/FirstWaveMessageModal.tscn"
var pauseMenuModal = "res://scenes/UI/PauseModalUI.tscn"
var showAdvertMenuModal = "res://scenes/UI/advert/ShowAdvertModalUI.tscn"

var currentPanel
var currentWaveModal


func showPauseMenu():
	hideCurrentWaveModal()
	get_tree().paused = true
	var pauseMenu = load(pauseMenuModal).instance()
	get_parent().add_child(pauseMenu)


func showAdvertModal(advertMob):
	hideCurrentWaveModal()
	get_tree().paused = true
	var advertModal = load(showAdvertMenuModal).instance()
	advertModal.init(advertMob)
	get_parent().add_child(advertModal)


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
	get_parent().call_deferred("add_child", firstWaveMessageModal)
	firstWaveMessageModal.call_deferred("display", nextWaveSeconds)
	currentWaveModal = firstWaveMessageModal


func showLevelBonusMenu(energySize, nextWaveSeconds):
	var waveBonus = load(waveBonusUrl).instance()
	get_parent().add_child(waveBonus)
	waveBonus.display(energySize, nextWaveSeconds)
	currentWaveModal = waveBonus


#################### end wave modals


func addBuyTowerMenuPanel():
	if is_instance_valid(currentPanel):
		_removePanel(currentPanel)
	var buyMenuUi = load(towerBuyMenuUrl).instance()
	get_parent().add_child(buyMenuUi)
	currentPanel = buyMenuUi
	return buyMenuUi


func addInfoPanel(entity):
	if is_instance_valid(currentPanel):
		_removePanel(currentPanel)
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

	currentPanel = _addInfoUI(entity, url)


func _unhandled_input(event):
	## reset all panels
	if event is InputEventMouseButton and event.is_pressed():
		_resetUi()


func _resetUi():
	_cleanupMouseSelection()
	_removePanel(currentPanel)


func _cleanupMouseSelection():
	var allSelectable = get_tree().get_nodes_in_group("selectable")
	for selectable in allSelectable:
		if is_instance_valid(selectable.selectSprite):
			selectable.selectSprite.visible = false
		if "radiusShape" in selectable:
			selectable.radiusShape.hide()


func _removePanel(panel):
	if is_instance_valid(panel):
		panel.queue_free()


func _addInfoUI(entity, sceneUrl):
	var infoIU = load(sceneUrl).instance()
	get_parent().add_child(infoIU)
	infoIU.init(entity)
	return infoIU
