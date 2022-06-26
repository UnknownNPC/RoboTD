extends Node

func cleanupMouseSelection():
	var allSelectable = get_tree().get_nodes_in_group("selectable")
	for selectable in allSelectable:
		selectable.clickAreaBorder.visible = false
		if "attackRadiusIntance" in selectable:
			selectable.attackRadiusIntance.visible = false
