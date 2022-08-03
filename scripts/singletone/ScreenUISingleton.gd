extends Node

var enemyInfoUrl = "res://scenes/UI/EnemyInfoUI.tscn"
var towerInfoUrl = "res://scenes/UI/TowerInfoUI.tscn"
var towerBuyMenuUrl = "res://scenes/UI/BuyTowerMenu.tscn"
var waveBonusUrl = "res://scenes/UI/WaveBonusUI.tscn"
var firstWaveMessageModalUrl = "res://scenes/UI/FirstWaveMessageModal.tscn"
var pauseMenuModal = "res://scenes/UI/PauseModalUI.tscn"

var currentPanel
var currentWaveModal


func showPauseMenu():
	get_tree().paused = true
	var pauseMenu = load(pauseMenuModal).instance()
	get_parent().add_child(pauseMenu)


################### start wave modals


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
	_resetUi()
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
	var url = enemyInfoUrl if isEnemy else towerInfoUrl
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
