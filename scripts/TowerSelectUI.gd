extends Node2D

onready var removeBtn = $Remove/CollisionShape2D/Button
onready var removeBtnPress = $Remove/CollisionShape2D/ButtonPressed
onready var removeResetClickSprite = $Remove/ResetClickSprite

onready var upBtn = $Up/CollisionShape2D/Button
onready var upBtnPress = $Up/CollisionShape2D/ButtonPressed
onready var upResetClickSprite = $Up/ResetClickSprite
onready var queueFreeTimer = $QueueFreeTimer

signal towerWasRemoved
signal towerLevelWasIncreased


func init(isMaxLevel, nextLevelCost):
	if isMaxLevel:
		$Up/Value.text = "Max"
		$Up.disconnect("input_event", self, "_on_Up_input_event")
	else:
		$Up/Value.text = str(nextLevelCost)


func _on_Up_input_event(viewport, event, shape_idx):
	if event.is_pressed():
		upResetClickSprite.start()
		upBtn.hide()
		upBtnPress.show()
		emit_signal("towerLevelWasIncreased")


func _on_Remove_input_event(viewport, event, shape_idx):
	if event.is_pressed():
		removeResetClickSprite.start()
		removeBtn.hide()
		removeBtnPress.show()
		emit_signal("towerWasRemoved")
		queueFreeTimer.start()


func _on_UpResetClickSprite_timeout():
	upResetClickSprite.stop()
	upBtn.show()
	upBtnPress.hide()


func _on_RemoveResetClickSprite_timeout():
	removeResetClickSprite.stop()
	removeBtn.show()
	removeBtnPress.hide()


func _on_QueueFreeTimer_timeout():
	queue_free()
