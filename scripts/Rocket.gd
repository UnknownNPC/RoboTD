extends "res://scripts/BaseFlyingAmmo.gd"

onready var rocket = $"."
onready var explosionPlayer = $ExplosionPlayer

signal enemyInTheExplosionArea(enemy)

var isExposionInAction = false


func _ready():
	ammoSpeed = 1.8


func ammoAction():
	only_once = false
	isFlying = false
	isExposionInAction = true
	if !isDemoMode:
		var enemiesInsideExplosion = rocket.get_overlapping_areas()
		for enemyInExplosion in enemiesInsideExplosion:
			if enemyInExplosion.is_in_group("enemies"):
				emit_signal("enemyInTheExplosionArea", enemyInExplosion)

	animation.play("explosion")
	if !isDemoMode:
		explosionPlayer.play()
	yield(animation, "animation_finished")
	queue_free()


func _on_Rocket_body_entered(body):
	if body.is_in_group("obstacles"):
		ammoAction()
