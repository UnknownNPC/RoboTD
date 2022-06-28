extends Node

var enemyInfoUrl = "res://scenes/UI/EnemyInfoUI.tscn"
var towerInfoUrl = "res://scenes/UI/TowerInfoUI.tscn"

var currentInfoPanel
var entity

func addInfoPanel(entity):
	var isEnemy = entity.is_in_group("enemies")
	var url = enemyInfoUrl if isEnemy else towerInfoUrl
	currentInfoPanel = _addInfoUI(entity, url)

func _input(event):
	## reset all panels
	if event is InputEventMouseButton and event.is_pressed():
		print("Reset UI")
		$"/root/Utils"._cleanupMouseSelection()
		$"/root/Utils"._removeInfoPanel()

func _cleanupMouseSelection():
	var allSelectable = get_tree().get_nodes_in_group("selectable")
	for selectable in allSelectable:
		selectable.spriteSelect.visible = false
		if "attackRadiusIntance" in selectable:
			selectable.attackRadiusIntance.visible = false

func _removeInfoPanel():
	if (is_instance_valid(currentInfoPanel)):
		currentInfoPanel.queue_free()

func _addInfoUI(entity, sceneUrl):
	var infoIU = load(sceneUrl).instance()
	get_parent().add_child(infoIU)
	infoIU.init(entity)
	return infoIU
