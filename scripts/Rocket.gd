extends "res://scripts/BaseFlyingAmmo.gd"

onready var rocket = $"."

signal enemyInTheExplosionArea(enemy)


func ammoAction():
	only_once = false
	isFlying = false

	animation.play("explosion")
	rocket.monitoring = true
	yield(animation, "animation_finished")
	queue_free()


func _on_Rocket_area_entered(enemy):
	if enemy.is_in_group("enemies"):
		emit_signal("enemyInTheExplosionArea", enemy)
