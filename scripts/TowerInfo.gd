extends Control

var tower

onready var nameValue = $BaseInfoUI/NameValue
onready var damageValue = $DamageValue
onready var aRateValue = $ARateValue
onready var radiusValue = $RadiusValue
onready var animation = $BaseInfoUI/Animation

onready var upgradeBtn = $Actions/Upgrade
onready var removeBtn = $Actions/Remove

var upgradeBtnText = "Rank Up - "

signal towerLevelBump
signal towerKill


func getPercentFromFloat(val: float):
	return "+" + str(val * 100) + "%"


func _process(delta):
	if is_instance_valid(tower):
		var targetAnimation = tower.currentAnimation.animation
		animation.animation = targetAnimation
		animation.frames.set_animation_loop(targetAnimation, true)

		initBtnStates()


func init(targetTower):
	tower = targetTower
	nameValue.text = tower.fullUnitName

	if targetTower.is_in_group("attackTowers"):
		var dmgV = "-" if tower.damageValue == 0 else tower.calcDamage()
		damageValue.text = str(dmgV)
		aRateValue.text = str(tower.calcCooldown())
	elif targetTower.is_in_group("bufferTowers"):
		damageValue.text = getPercentFromFloat(tower.damageBufferPercentValue)
		aRateValue.text = getPercentFromFloat(tower.attackBufferPercentCooldown)

	radiusValue.text = str(tower.effectRadius)

	animation.frames = tower.currentAnimation.frames.duplicate()
	animation.animation = tower.currentAnimation.animation
	animation.scale = Vector2(3, 3)

	connect("towerLevelBump", targetTower, "_towerLevelWasIncreased")
	connect("towerKill", targetTower, "_towerWasRemoved")

	initBtnStates()


func _on_Upgrade_pressed():
	emit_signal("towerLevelBump")


func _on_Remove_pressed():
	emit_signal("towerKill")


func initBtnStates():
	var isMax = isMaxLvl()
	if isMax:
		upgradeBtn.text = "Max Rank"
		upgradeBtn.disabled = true
		upgradeBtn.icon = null
	else:
		var nextLevelCost = getNextLvlCost()
		upgradeBtn.text = upgradeBtnText + str(nextLevelCost)
		var isEnoughEnergy = $"/root/GameProcessState".energyCounter >= nextLevelCost
		if isEnoughEnergy:
			upgradeBtn.disabled = false
		else:
			upgradeBtn.disabled = true


func isMaxLvl():
	if is_instance_valid(tower):
		return tower.currentLevel >= tower.maxLevel
	else:
		return true


func getNextLvlCost():
	if is_instance_valid(tower):
		return tower.level2Cost if tower.currentLevel == 1 else tower.level3Cost
	else:
		return 0
