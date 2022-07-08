extends "res://scripts/BaseFlyingAmmo.gd"

signal rocketExplosion(radius)
export var damageRadius = 25

func ammoAction():
	only_once = false
	isFlying = false

	emit_signal("rocketExplosion", damageRadius)
	animation.play("explosion")
	yield(animation, "animation_finished")
	queue_free()
	
