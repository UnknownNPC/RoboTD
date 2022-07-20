### Should be AFTER WAVE_SPAWNER
extends "res://scripts/BaseTower.gd"

export(int) var damageValue = 100
export(float) var attackCooldown = 1.0

onready var attackTimer = $AttackTimer

var attackTarget = null
var canMakeShoot = true


func _ready():
	attackTimer.wait_time = attackCooldown


func _process(delta):
	if attackTimer.wait_time != attackCooldown:
		attackTimer.wait_time = attackCooldown

	### Attack
	if !is_instance_valid(attackTarget):
		var allEnemies = get_tree().get_nodes_in_group("enemies")
		for enemy in allEnemies:
			var isEnemyInsideRadius = isEnemyInsideAttackRadius(enemy)
			if !enemy.isDead && isEnemyInsideRadius:
				attackTarget = enemy
				break
			else:
				attackTarget = null
	else:
		var isEnemyStilInside = isEnemyInsideAttackRadius(attackTarget)
		if !isEnemyStilInside || attackTarget.isDead:
			attackTarget = null
			return

		var isEmemyOnTheLeft = global_position.x - attackTarget.global_position.x > 0
		if isEmemyOnTheLeft:
			currentAnimation.flip_h = true
		else:
			currentAnimation.flip_h = false

		# Shoot action
		if canMakeShoot:
			currentAnimation.animation = "fire"
			currentAnimation.frame = 0
			howToDamage()
			attackTimer.start()
			canMakeShoot = false

	if !is_instance_valid(attackTarget):
		currentAnimation.animation = "idle"


func howToDamage():
	attackTarget.add_damage(damageValue)


func levelUpParams():
	damageValue += 5
	effectRadius += 10
	attackCooldown -= 0.1


func _on_AttackTimer_timeout():
	canMakeShoot = true


func isEnemyInsideAttackRadius(enemy):
	return (
		(
			pow(enemy.global_position.x - global_position.x, 2)
			+ pow(enemy.global_position.y - global_position.y, 2)
		)
		<= pow(effectRadius, 2)
	)
