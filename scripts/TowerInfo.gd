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

func _process(delta):
	if is_instance_valid(tower):
		var targetAnimation = tower.currentAnimation.animation
		animation.animation = targetAnimation
		animation.frames.set_animation_loop(targetAnimation, true)

func init(targetTower):
	tower = targetTower
	nameValue.text = tower.unitName
	damageValue.text = str(tower.damageValue)
	aRateValue.text = str(tower.attackCooldown)
	radiusValue.text = str(tower.attackRadius)

	animation.frames = tower.currentAnimation.frames.duplicate()
	animation.animation = tower.currentAnimation.animation
	animation.scale = Vector2(3, 3)
	
	connect("towerLevelBump", targetTower, "_towerLevelWasIncreased")
	connect("towerKill", targetTower, "_towerWasRemoved")
	
	var isMax = targetTower.currentLevel >= targetTower.maxLevel
	if (isMax):
		upgradeBtn.text = "Max Rank"
		upgradeBtn.disabled = true
	else:
		var nextLevelCost = tower.level2Cost if tower.currentLevel == 1 else tower.level3Cost
		upgradeBtn.text = upgradeBtnText + str(nextLevelCost)

func _on_Upgrade_pressed():
	print("press")
	emit_signal("towerLevelBump")

func _on_Remove_pressed():
	print("press")
	emit_signal("towerKill")
