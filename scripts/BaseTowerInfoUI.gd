extends Control

var tower

onready var rankValue = $RankValue
onready var animation = $BaseInfoUI/Animation

onready var upgradeBtn = $Actions/Upgrade
onready var removeBtn = $Actions/Remove

var upgradeBtnText = "Rank Up -"
var removeBtnText = "Remove +"

signal towerLevelBump
signal towerKill


func getPercentFromFloat(val: float):
	return str(val * 100) + "%"


func _process(delta):
	if is_instance_valid(tower):
		var targetAnimation = tower.currentAnimation.animation
		animation.animation = targetAnimation
		animation.frames.set_animation_loop(targetAnimation, true)

		initBtnStates()


func init(targetTower):
	tower = targetTower
	rankValue.text = tower.fullUnitName

#	if targetTower.is_in_group("attackTowers"):
#		var dmgV = "-" if tower.damageValue == 0 else tower.calcDamage()
#		damageValue.text = str(dmgV)
#		aRateValue.text = str(tower.calcCooldown())
#	elif targetTower.is_in_group("bufferTowers"):
#
#
#	radiusValue.text = str(tower.effectRadius)

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
	removeBtn.text = removeBtnText + str(getCurrentCost() / 2)
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


func getCurrentCost():
	if is_instance_valid(tower):
		if tower.currentLevel == 1:
			return tower.buyCost
		elif tower.currentLevel == 2:
			return tower.level2Cost
		else:
			return tower.level3Cost
	else:
		return 0
