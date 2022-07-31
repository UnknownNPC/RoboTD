extends "res://scripts/BaseFlyingAmmo.gd"

onready var rocket = $"."

signal enemyInTheExplosionArea(enemy)

var isExposionInAction = false


func ammoAction():
	only_once = false
	isFlying = false
	isExposionInAction = true

	var enemiesInsideExplosion = rocket.get_overlapping_areas()
	for enemyInExplosion in enemiesInsideExplosion:
		if enemyInExplosion.is_in_group("enemies"):
			emit_signal("enemyInTheExplosionArea", enemyInExplosion)

	animation.play("explosion")
	yield(animation, "animation_finished")
	queue_free()


#enemies entered to explosion area
func _on_Rocket_area_entered(smth: Area2D):
	if smth.is_in_group("enemies"):
		if isExposionInAction:
			emit_signal("enemyInTheExplosionArea", smth)


func _on_Rocket_body_entered(body):
	if body.is_in_group("obstacles"):
		ammoAction()
