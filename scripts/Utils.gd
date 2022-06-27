extends Node

var enemyInfoUrl = "res://scenes/UI/EnemyInfoUI.tscn"
var towerInfoUrl = "res://scenes/UI/TowerInfoUI.tscn"

var currentInfoPanel
var entity

func _input(event):
	## reset all panel outside selectable entities
	if event is InputEventMouseButton and event.is_pressed():
		var allSelectable = get_tree().get_nodes_in_group("selectable")
		var isOnSelectable = false
		for selectable in allSelectable:
			var selectableCollision = selectable.get_node("SelectSprite/Collision")
			var selectableRadius = selectableCollision.shape.radius
			var isClickInside = pow((event.global_position.x - selectable.global_position.x),2) + pow((event.global_position.y - selectable.global_position.y),2) <= pow(selectableRadius, 2)
			if isClickInside:
				isOnSelectable = true
				break
		if (!isOnSelectable):
			$"/root/Utils".cleanupMouseSelection()
			$"/root/Utils".removeInfoPanel()

func cleanupMouseSelection():
	var allSelectable = get_tree().get_nodes_in_group("selectable")
	for selectable in allSelectable:
		selectable.spriteSelect.visible = false
		if "attackRadiusIntance" in selectable:
			selectable.attackRadiusIntance.visible = false

func removeInfoPanel():
	if (is_instance_valid(currentInfoPanel)):
		currentInfoPanel.queue_free()

func addInfoPanel(entity):
	removeInfoPanel()
	var isEnemy = entity.is_in_group("enemies")
	var url = enemyInfoUrl if isEnemy else towerInfoUrl
	currentInfoPanel = _addInfoUI(entity, url)

func _addInfoUI(entity, sceneUrl):
	var infoIU = load(sceneUrl).instance()
	get_parent().add_child(infoIU)
	infoIU.init(entity)
	return infoIU
