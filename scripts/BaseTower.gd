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

onready var spriteSelect = $SelectSprite/Select
onready var spriteShape = $SelectSprite/Collision
onready var attackRadiusShape = $AttackRadiusCircle

onready var animationLv1 = $AnimationLv1
onready var animationLv2 = $AnimationLv2
onready var animationLv3 = $AnimationLv3

var currentAnimation
var currentLevel = 1
var maxLevel = 3

func _ready():
	attackRadiusShape.init(attackRadius)
	initCurrentAnimation()
	initFullUnitName()

func _on_SelectSprite_input_event(viewport, event, shape_idx):
	if (event.is_pressed()):
		selfSelect()

func selfSelect():
		$"/root/ScreenUISingleton"._resetUi()
		spriteSelect.show()
		$"/root/ScreenUISingleton".addInfoPanel(self)
		attackRadiusShape.show()
		
func _towerLevelWasIncreased():
	currentLevel += 1
	initFullUnitName()
	initCurrentAnimation()
	levelUpParams()
	$"/root/ScreenUISingleton".addInfoPanel(self)
	attackRadiusShape.init(attackRadius)
	attackRadiusShape.show()
	$"/root/GameProcessState".getEnergy(getNextLvlCost())

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
		
