extends Node

var enemyInfoUrl = "res://scenes/UI/EnemyInfoUI.tscn"
var towerInfoUrl = "res://scenes/UI/TowerInfoUI.tscn"

var currentInfoPanel
var entity

func cleanupMouseSelection():
	var allSelectable = get_tree().get_nodes_in_group("selectable")
	for selectable in allSelectable:
		selectable.clickAreaBorder.visible = false
		if "attackRadiusIntance" in selectable:
			selectable.attackRadiusIntance.visible = false

func addInfoPanel(entity):
	if (is_instance_valid(currentInfoPanel)):
		currentInfoPanel.queue_free()
	var isEnemy = entity.is_in_group("enemies")
	var url = enemyInfoUrl if isEnemy else towerInfoUrl
	currentInfoPanel = _addInfoUI(entity, url)

func _addInfoUI(entity, sceneUrl):
	var infoIU = load(sceneUrl).instance()
	get_parent().add_child(infoIU)
	infoIU.init(entity)
	return infoIU
