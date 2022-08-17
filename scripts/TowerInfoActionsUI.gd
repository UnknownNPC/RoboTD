extends Control

onready var upgradeBtn = $Upgrade
onready var removeBtn = $Remove

var upgradeBtnText = "Rank Up -"
var removeBtnText = "Remove +"

var tower

signal towerLevelBump
signal towerKill


func _process(delta):
	if is_instance_valid(tower):
		initBtnStates()


func init(targetTower):
	tower = targetTower

	connect("towerLevelBump", targetTower, "_towerLevelWasIncreased")
	connect("towerKill", targetTower, "_towerWasRemoved")

	initBtnStates()


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


func _on_Upgrade_pressed():
	emit_signal("towerLevelBump")


func _on_Remove_pressed():
	emit_signal("towerKill")
