extends "res://scripts/BaseTower.gd"

export(float) var damageBufferPercentValue = 0.1
export(float) var attackBufferPercentCooldown = 0.1


func levelUpParams():
	damageBufferPercentValue += 0.05
	attackBufferPercentCooldown += 0.05
