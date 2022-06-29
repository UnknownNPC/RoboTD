extends Node

var enemyInfoUrl = "res://scenes/UI/EnemyInfoUI.tscn"
var towerInfoUrl = "res://scenes/UI/TowerInfoUI.tscn"
var towerSelectUiUrl = "res://scenes/UI/TowerSelectUI.tscn"

var currentInfoPanel
var currentTowerSelectPanel

func addTowerSelectPanel(tower):
	var towerSelect = load(towerSelectUiUrl).instance()
	towerSelect.global_position = tower.global_position
	towerSelect.global_position += Vector2(50, -50)
	towerSelect.scale = Vector2(0.6, 0.6)
	towerSelect.connect("towerWasRemoved", tower, "_towerWasRemoved")
	towerSelect.connect("towerLevelWasIncreased", tower, "_towerLevelWasIncreased")

	get_parent().add_child(towerSelect)
	# set settings
	currentTowerSelectPanel = towerSelect
	initTowerSelectPanel(tower)

func initTowerSelectPanel(tower):
	if(is_instance_valid(currentTowerSelectPanel)):
		var isMaxLevel = tower.currentLevel >= tower.maxLevel
		var nextLevelCost = tower.level2Cost if tower.currentLevel == 1 else tower.level3Cost
		currentTowerSelectPanel.init(isMaxLevel, nextLevelCost)

func addInfoPanel(entity):
	var isEnemy = entity.is_in_group("enemies")
	var url = enemyInfoUrl if isEnemy else towerInfoUrl
	currentInfoPanel = _addInfoUI(entity, url)

func _input(event):
	## reset all panels
	if event is InputEventMouseButton and event.is_pressed():
		if (is_instance_valid(currentTowerSelectPanel)):
			var border = currentTowerSelectPanel.get_node("Border")
			var tile_pos = border.world_to_map(border.to_local(event.position))
			var cell = border.get_cellv(tile_pos)
			if (cell == -1):
				_resetUi()
		else:	
			_resetUi()

func _resetUi():
		_cleanupMouseSelection()
		_removePanel(currentInfoPanel)
		_removePanel(currentTowerSelectPanel)
		

func _cleanupMouseSelection():
	var allSelectable = get_tree().get_nodes_in_group("selectable")
	for selectable in allSelectable:
		selectable.spriteSelect.visible = false
		if "attackRadiusIntance" in selectable:
			selectable.attackRadiusIntance.visible = false

func _removePanel(panel):
	if (is_instance_valid(panel)):
		panel.queue_free()

func _addInfoUI(entity, sceneUrl):
	var infoIU = load(sceneUrl).instance()
	get_parent().add_child(infoIU)
	infoIU.init(entity)
	return infoIU
