extends Node

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
