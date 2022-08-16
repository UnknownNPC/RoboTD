extends "res://scripts/BaseFlyingAmmo.gd"

onready var smokeCloudTimer = $SmokeCloudTimer
onready var smokeArea = $SmokeArea
onready var smokeCloudAnimation = $SmokeArea/SmokeAnimation

var grandeSlownessModifier = null


func _ready():
	lerpSpeedConstant = 0.4


func initSmokeGranade(attackPoint, direction, effectValue, effectDurationSec):
	.init(attackPoint, direction)
	grandeSlownessModifier = effectValue
	smokeCloudTimer.wait_time = effectDurationSec


func _on_SmokeArea_area_entered(area):
	if area.is_in_group("enemies"):
		area.slownessModifier = grandeSlownessModifier


func _on_SmokeArea_area_exited(area):
	if area.is_in_group("enemies"):
		area.slownessModifier = 1


func ammoAction():
	only_once = false
	isFlying = false

	animation.hide()

	smokeArea.monitoring = true
	var enemiesInsideSmoke = smokeArea.get_overlapping_areas()
	for enemyInSmoke in enemiesInsideSmoke:
		if enemyInSmoke.is_in_group("enemies"):
			enemyInSmoke.slownessModifier = grandeSlownessModifier

	smokeCloudAnimation.show()
	smokeCloudAnimation.play("smoke_action")

	smokeCloudTimer.start()


func _on_SmokeCloudTimer_timeout():
	smokeCloudAnimation.play("smoke_disapearing")
	yield(smokeCloudAnimation, "animation_finished")
	queue_free()


### flying granade
func _on_Grenade_body_entered(body):
	if body.is_in_group("obstacles"):
		ammoAction()
