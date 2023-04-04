### Should be AFTER WAVE_SPAWNER
extends "res://scripts/BaseTower.gd"

enum States { SEARCHING_TARGET, ATTACK }

export(int) var damageValue = 100
export(float) var attackCooldown = 1.0

onready var attackTimer = $AttackTimer
onready var reloadingState = $ReloadingState
onready var warnEmoji = $WarnEmoji
onready var shootPlayer = $ShootPlayer

var attackTarget = null
var canMakeShoot = true
var currentState = States.SEARCHING_TARGET

var buffersAround = {}

onready var reloadStatePrevVal = reloadingState.value


func _ready():
	attackTimer.wait_time = attackCooldown
	if demoMode:
		reloadingState.hide()


func _process(_delta):
	var lerpValue = range_lerp(attackTimer.time_left, attackTimer.wait_time, 0, 0, 100)
	var lerpValueFloor = floor(lerpValue)
	if lerpValueFloor != reloadStatePrevVal:
		reloadingState.value = lerpValueFloor
		reloadStatePrevVal = lerpValueFloor

	var cooldownWithBuffers = calcCooldown()
	if attackTimer.wait_time != cooldownWithBuffers:
		attackTimer.wait_time = cooldownWithBuffers

	match currentState:
		States.SEARCHING_TARGET:
			var allEnemies = get_tree().get_nodes_in_group("enemies")
			for enemy in allEnemies:
				var isEnemyInsideRadius = isSmthInsideRadius(self, enemy, effectRadius)
				if isEnemyInsideRadius and !enemy.isDead:
					attackTarget = enemy
					currentState = States.ATTACK

					### was idling
					if currentAnimation.animation == "idle" and !demoMode:
						warnEmoji.showWarn()
					break
			# if nothing found - switch to idle animation
			if !is_instance_valid(attackTarget):
				currentAnimation.animation = "idle"

		States.ATTACK:
			# check if still valid
			var isEnemyStilInside = isSmthInsideRadius(self, attackTarget, effectRadius)
			if !isEnemyStilInside || attackTarget.isDead:
				attackTarget = null
				currentState = States.SEARCHING_TARGET
				# interupt if not
				return

			# turn to enemy
			var isEmemyOnTheLeft = global_position.x - attackTarget.global_position.x > 0
			if isEmemyOnTheLeft:
				currentAnimation.flip_h = true
			else:
				currentAnimation.flip_h = false

			# Shoot action
			if canMakeShoot:
				if !demoMode:
					shootPlayer.play()
				currentAnimation.animation = "fire"
				currentAnimation.frame = 0
				howToDamage()
				attackTimer.start()
				canMakeShoot = false

	# update buffers around
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
	attackTarget.add_damage(calcDamage())


func calcDamage():
	if demoMode:
		return 0

	var newDamage = damageValue
	for bufferAroundMeHash in buffersAround:
		var bufferArround = buffersAround[bufferAroundMeHash]
		newDamage += newDamage * bufferArround.damageBufferPercentValue
	return newDamage


func calcCooldown():
	var newAttackCooldown = attackCooldown
	for bufferAroundMeHash in buffersAround:
		var bufferArround = buffersAround[bufferAroundMeHash]
		if is_instance_valid(bufferArround):
			newAttackCooldown -= newAttackCooldown * bufferArround.attackBufferPercentCooldown
	return newAttackCooldown


func levelUpParams():
	damageValue += 5
	effectRadius += 10
	attackCooldown -= 0.1


func _on_AttackTimer_timeout():
	canMakeShoot = true
	attackTimer.stop()
