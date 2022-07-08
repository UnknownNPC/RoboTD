extends "res://scripts/BaseFlyingAmmo.gd"

signal enemyInCloud(enemy)

onready var smokeCloudTimer = $SmokeCloudTimer
onready var smokeArea = $SmokeArea
onready var smokeCloudAnimation = $SmokeArea/SmokeAnimation

export var grandeSlownessModifier = 0.6

func _ready():
	duration = 0.4

func _on_SmokeArea_area_entered(area):
	if (area.is_in_group("enemies")):
		area.slownessModifier = grandeSlownessModifier
		emit_signal("enemyInCloud", area)


func _on_SmokeArea_area_exited(area):
	if (area.is_in_group("enemies")):
		area.slownessModifier = 1

func ammoAction():
	only_once = false
	isFlying = false
	
	animation.hide()
	
	smokeArea.monitoring = true
	smokeCloudAnimation.show()
	smokeCloudAnimation.play("smoke_action")
	
	smokeCloudTimer.start()

func _on_SmokeCloudTimer_timeout():
	smokeCloudAnimation.play("smoke_disapearing")
	yield(smokeCloudAnimation, "animation_finished")
	queue_free()
