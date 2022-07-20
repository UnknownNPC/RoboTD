### Should be AFTER WAVE_SPAWNER
extends "res://scripts/BaseTower.gd"

export(int) var damageValue = 100
export(float) var attackCooldown = 1.0

onready var attackTimer = $AttackTimer

var attackTarget = null
var canMakeShoot = true

var buffersAround = {}


func _ready():
	attackTimer.wait_time = attackCooldown


func _process(delta):
	if attackTimer.wait_time != attackCooldown:
		attackTimer.wait_time = attackCooldown

	### Attack
	if !is_instance_valid(attackTarget):
		var allEnemies = get_tree().get_nodes_in_group("enemies")
		for enemy in allEnemies:
			var isEnemyInsideRadius = isSmthInsideRadius(self, enemy, effectRadius)
			if !enemy.isDead && isEnemyInsideRadius:
				attackTarget = enemy
				break
			else:
				attackTarget = null
	else:
		var isEnemyStilInside = isSmthInsideRadius(self, attackTarget, effectRadius)
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

	### check if we have a buffer around
	var allBuffersAround = get_tree().get_nodes_in_group("bufferTowers")
	for bufferOnMap in allBuffersAround:
		# check if im inside buffer radius
		var bufferHash = hash(bufferOnMap)
		if (
			isSmthInsideRadius(bufferOnMap, self, bufferOnMap.effectRadius)
			and !buffersAround.has(bufferHash)
		):
			buffersAround[bufferHash] = bufferOnMap

	## remove dead buffers
	for bufferAroundMeHash in buffersAround:
		var bufferArround = buffersAround[bufferAroundMeHash]
		if !is_instance_valid(bufferArround):
			buffersAround.erase(bufferAroundMeHash)


func howToDamage():
	attackTarget.add_damage(damageValue)


func calcDamage():
	var newDamage = damageValue
	for bufferAroundMeHash in buffersAround:
		var bufferArround = buffersAround[bufferAroundMeHash]
		newDamage += newDamage * bufferArround.damageBufferPercentValue
	return newDamage


func calcCooldown():
	var newAttackCooldown = attackCooldown
	for bufferAroundMeHash in buffersAround:
		var bufferArround = buffersAround[bufferAroundMeHash]
		newAttackCooldown -= newAttackCooldown * bufferArround.attackBufferPercentCooldown
	return newAttackCooldown


func levelUpParams():
	damageValue += 5
	effectRadius += 10
	attackCooldown -= 0.1


func _on_AttackTimer_timeout():
	canMakeShoot = true


func isSmthInsideRadius(obj, targetObj, radius):
	return (
		(
			pow(targetObj.global_position.x - obj.global_position.x, 2)
			+ pow(targetObj.global_position.y - obj.global_position.y, 2)
		)
		<= pow(radius, 2)
	)
