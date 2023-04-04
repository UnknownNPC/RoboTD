extends "res://scripts/BaseTowerInfoUI.gd"

onready var damageValue = $DamageValue
onready var reloadValue = $ReloadValue
onready var rangeValue = $RangeValue


func init(targetTower):
	.init(targetTower)

	damageValue.text = "+" + getPercentFromFloat(tower.damageBufferPercentValue)
	reloadValue.text = "+" + getPercentFromFloat(tower.attackBufferPercentCooldown)
	rangeValue.text = str(tower.effectRadius)
