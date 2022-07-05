extends Node

var enemyInfoUrl = "res://scenes/UI/EnemyInfoUI.tscn"
var towerInfoUrl = "res://scenes/UI/TowerInfoUI.tscn"
var towerBuyMenuUrl = "res://scenes/UI/BuyTowerMenu.tscn"

var currentPanel

func addBuyTowerMenuPanel():
	if (is_instance_valid(currentPanel)):
		_removePanel(currentPanel)
	var buyMenuUi = load(towerBuyMenuUrl).instance()
	get_parent().add_child(buyMenuUi)
	currentPanel = buyMenuUi
	return buyMenuUi

func addInfoPanel(entity):
	if (is_instance_valid(currentPanel)):
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
		selectable.selectSprite.visible = false
		if "attackRadiusShape" in selectable:
			selectable.attackRadiusShape.hide()

func _removePanel(panel):
	if (is_instance_valid(panel)):
		panel.queue_free()

func _addInfoUI(entity, sceneUrl):
	var infoIU = load(sceneUrl).instance()
	get_parent().add_child(infoIU)
	infoIU.init(entity)
	return infoIU
