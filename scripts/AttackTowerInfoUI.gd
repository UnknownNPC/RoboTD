extends "res://scripts/BaseTowerInfoUI.gd"

onready var damageValue = $DamageValue
onready var reloadValue = $ReloadValue
onready var rangeValue = $RangeValue


func init(targetTower):
	.init(targetTower)
	damageValue.text = str(tower.calcDamage())
	reloadValue.text = str(tower.calcCooldown()) + " sec"
	rangeValue.text = str(tower.effectRadius)
