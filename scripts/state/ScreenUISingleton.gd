extends Node

var enemyInfoUrl = "res://scenes/UI/EnemyInfoUI.tscn"
var towerInfoUrl = "res://scenes/UI/TowerInfoUI.tscn"
var towerSelectUiUrl = "res://scenes/UI/TowerSelectUI.tscn"

var currentInfoPanel
var currentTowerSelectPanel

func addTowerSelectPanel(tower):
	_removePanel(currentTowerSelectPanel)
	var towerSelect = load(towerSelectUiUrl).instance()
	towerSelect.global_position = tower.global_position
	towerSelect.scale = Vector2(0.6, 0.6)
	towerSelect.connect("towerWasRemoved", tower, "_towerWasRemoved")
	towerSelect.connect("towerLevelWasIncreased", tower, "_towerLevelWasIncreased")

	get_parent().add_child(towerSelect)
	
	## modify X positiin - it should be inside viewport
	var selectBorder = towerSelect.get_node("Border")
	var borderWidth = selectBorder.get_used_rect().size.x * selectBorder.cell_size.x * selectBorder.scale.x	
	var borderRightLimit = towerSelect.global_position.x + borderWidth
	var isOutsideRightViewport = get_viewport().size.x <= borderRightLimit
	var offset = tower.currentAnimation.frames.get_frame("idle", 0).get_width()
	if (isOutsideRightViewport):
		#spawn right from tower
		towerSelect.global_position.x -=  borderWidth / 2 * towerSelect.scale.x + offset
	else:
		#spawn left from tower
		towerSelect.global_position.x +=  borderWidth / 2 * towerSelect.scale.x + offset

	currentTowerSelectPanel = towerSelect
	initTowerSelectPanel(tower)

func initTowerSelectPanel(tower):
	if(is_instance_valid(currentTowerSelectPanel)):
		var isMaxLevel = tower.currentLevel >= tower.maxLevel
		var nextLevelCost = tower.level2Cost if tower.currentLevel == 1 else tower.level3Cost
		currentTowerSelectPanel.init(isMaxLevel, nextLevelCost)

func addInfoPanel(entity):
	if (is_instance_valid(currentInfoPanel)):
		_removePanel(currentInfoPanel)
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
