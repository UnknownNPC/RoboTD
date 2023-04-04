extends "res://scripts/BaseTower.gd"

export(float) var damageBufferPercentValue = 0.1
export(float) var attackBufferPercentCooldown = 0.1


func levelUpParams():
	damageBufferPercentValue += 0.05
	attackBufferPercentCooldown += 0.05


var towerAroundBuffer = null


func _process(_delta):
	if !is_instance_valid(towerAroundBuffer):
		var attackTowers = get_tree().get_nodes_in_group("attackTowers")

		for attackTower in attackTowers:
			var isTowerInRadius = isSmthInsideRadius(self, attackTower, effectRadius)
			if isTowerInRadius and is_instance_valid(attackTower):
				towerAroundBuffer = attackTower
				break
			else:
				towerAroundBuffer = null

	if is_instance_valid(towerAroundBuffer):
		self.currentAnimation.flip_h = towerAroundBuffer.currentAnimation.flip_h
