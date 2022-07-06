### Should be AFTER WAVE_SPAWNER
extends Node2D

var spawnPointScene = "res://scenes/SpawnPoint.tscn"
onready var spawnPointsNode = $"/root/BaseLevel/TowerSpawnPoints"

export (String) var unitName
export (int) var damageValue = 100
export (int) var attackRadius = 120
export (float) var attackCooldown = 1.0

var level1NamePrefix = "RT "
var level2NamePrefix = "SGT "
var level3NamePrefix = "SGM "

var fullUnitName = ""

export (int) var buyCost = 25
export (int) var level2Cost = 10
export (int) var level3Cost = 15

onready var selectSprite = $SelectSprite/Select
onready var selectShapeCollision = $SelectSprite/Collision


onready var attackRadiusShape = $AttackRadiusCircle

onready var animationLv1 = $AnimationLv1
onready var animationLv2 = $AnimationLv2
onready var animationLv3 = $AnimationLv3

onready var attackTimer = $AttackTimer

var currentAnimation
var currentLevel = 1
var maxLevel = 3

var attackTarget = null
var canMakeShoot = true

func _ready():
	attackTimer.wait_time = attackCooldown

	initCurrentAnimation()
	currentAnimation.animation = "idle"

	attackRadiusShape.init(attackRadius)
	initFullUnitName()

func _process(delta):
	if (attackTimer.wait_time != attackCooldown):
		attackTimer.wait_time = attackCooldown
	
	### Attack
	if (!is_instance_valid(attackTarget)):
		var allEnemies = get_tree().get_nodes_in_group("enemies")
		for enemy in allEnemies:
			var isEnemyInsideRadius = isEnemyInsideAttackRadius(enemy)
			if  (!enemy.isDead && isEnemyInsideRadius):
				attackTarget = enemy
				break
			else:
				attackTarget = null
	else:
		var isEnemyStilInside = isEnemyInsideAttackRadius(attackTarget)
		if (!isEnemyStilInside || attackTarget.isDead):
			attackTarget = null
			return
		
		var isEmemyOnTheLeft = global_position.x - attackTarget.global_position.x > 0
		if (isEmemyOnTheLeft):
			currentAnimation.flip_h = true
		else:
			currentAnimation.flip_h = false

		# Shoot action
		if (canMakeShoot):
			currentAnimation.animation = "fire"
			currentAnimation.frame = 0
			howToDamage()
			attackTimer.start()
			canMakeShoot = false
	
	if (!is_instance_valid(attackTarget)):
		currentAnimation.animation = "idle"

func howToDamage():
	attackTarget.add_damage(damageValue)

func _on_SelectSprite_input_event(viewport, event, shape_idx):
	if (event.is_pressed()):
		selfSelect()

func selfSelect():
		$"/root/ScreenUISingleton"._resetUi()
		selectSprite.show()
		$"/root/ScreenUISingleton".addInfoPanel(self)
		attackRadiusShape.show()
		
func _towerLevelWasIncreased():
	$"/root/GameProcessState".getEnergy(getNextLvlCost())
	currentLevel += 1
	initFullUnitName()
	initCurrentAnimation()
	levelUpParams()
	$"/root/ScreenUISingleton".addInfoPanel(self)
	attackRadiusShape.init(attackRadius)
	attackRadiusShape.show()

func _towerWasRemoved():
	var spawnPoint = load(spawnPointScene).instance()
	spawnPoint.global_position = self.global_position
	spawnPointsNode.add_child(spawnPoint)
	queue_free()
	$"/root/ScreenUISingleton"._resetUi()

func levelUpParams():
	damageValue += 5
	attackRadius += 10
	attackCooldown -= 0.1

func initCurrentAnimation():
	if currentLevel == 1:
		currentAnimation = animationLv1
	elif(currentLevel == 2):
		animationLv1.hide()
		animationLv2.show()
		currentAnimation = animationLv2
		currentAnimation.flip_h = animationLv1.flip_h
	else:
		animationLv2.hide()
		animationLv3.show()
		currentAnimation = animationLv3
		currentAnimation.flip_h = animationLv2.flip_h
		
func getNextLvlCost():
	return self.level2Cost if self.currentLevel == 1 else self.level3Cost

func initFullUnitName():
	if (currentLevel == 1):
		fullUnitName = level1NamePrefix + unitName
	elif (currentLevel == 2):
		fullUnitName = level2NamePrefix + unitName 
	else:
		fullUnitName = level3NamePrefix + unitName 

func _on_AttackTimer_timeout():
	canMakeShoot = true

func isEnemyInsideAttackRadius(enemy):
	return pow((enemy.global_position.x - global_position.x),2) + pow((enemy.global_position.y - global_position.y),2) <= pow(attackRadius, 2)
