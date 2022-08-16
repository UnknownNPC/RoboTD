extends "res://scripts/BaseTowerInfoUI.gd"

onready var effectValue = $EffectValue
onready var durationValue = $DurationValue
onready var reloadValue = $ReloadValue
onready var rangeValue = $RangeValue

var effectTypeValueFormat = "%s %s"


func init(targetTower):
	.init(targetTower)
	effectValue.text = (
		effectTypeValueFormat
		% [tower.effectType, str(getPercentFromFloat(tower.effectValue))]
	)
	durationValue.text = str(tower.effectDurationSec) + " sec"
	reloadValue.text = str(tower.calcCooldown())
	rangeValue.text = str(tower.effectRadius)
