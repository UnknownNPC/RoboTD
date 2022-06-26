extends Node

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
	 	var allSelectable = get_tree().get_nodes_in_group("selectable")
		for selectable in allSelectable
			
			
