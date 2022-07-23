extends Node2D

var spawnPointScene = "res://scenes/SpawnPoint.tscn"
onready var spawnPointsNode = get_tree().get_root().find_node("TowerSpawnPoints", true, false)

var level1NamePrefix = "RT "
var level2NamePrefix = "SGT "
var level3NamePrefix = "SGM "

var fullUnitName = ""

export(String) var unitName
export(int) var buyCost = 0
export(int) var level2Cost = 0
export(int) var level3Cost = 0
# for demo menu settings
export(bool) var demoMode = false
export(int) var demoAnimationLevel = 1

onready var selectSprite = $SelectSprite/Select
onready var selectShapeCollision = $SelectSprite/Collision
onready var radiusShape = $RadiusCircle
onready var animationLv1 = $AnimationLv1
onready var animationLv2 = $AnimationLv2
onready var animationLv3 = $AnimationLv3

var currentAnimation
var currentLevel = 1
var maxLevel = 3

export(int) var effectRadius = 120


func _ready():
	radiusShape.init(effectRadius)
	initCurrentAnimation()
	initFullUnitName()
	if demoMode:
		selectSprite.queue_free()
		selectShapeCollision.queue_free()


func _on_SelectSprite_input_event(viewport, event, shape_idx):
	if event.is_pressed():
		selfSelect()


func selfSelect():
	$"/root/ScreenUISingleton"._resetUi()
	selectSprite.show()
	$"/root/ScreenUISingleton".addInfoPanel(self)
	radiusShape.show()


## EXTERNAL SIGNALS!!!
func _towerWasRemoved():
	var spawnPoint = load(spawnPointScene).instance()
	spawnPoint.global_position = self.global_position
	spawnPointsNode.add_child(spawnPoint)
	queue_free()
	spawnPoint.selfSelect()


func _towerLevelWasIncreased():
	$"/root/GameProcessState".getEnergy(getNextLvlCost())
	currentLevel += 1
	initFullUnitName()
	initCurrentAnimation()
	levelUpParams()
	$"/root/ScreenUISingleton".addInfoPanel(self)
	radiusShape.init(effectRadius)
	radiusShape.show()


## EXTERNAL SIGNALS END!!!


func levelUpParams():
	print("OVERRIDE ME")


func getNextLvlCost():
	return self.level2Cost if self.currentLevel == 1 else self.level3Cost


func initCurrentAnimation():
	if (currentLevel == 1 and !demoMode) or (demoAnimationLevel == 1 and demoMode):
		currentAnimation = animationLv1
	elif (currentLevel == 2 and !demoMode) or (demoAnimationLevel == 2 and demoMode):
		animationLv1.hide()
		animationLv2.show()
		currentAnimation = animationLv2
		currentAnimation.flip_h = animationLv1.flip_h
	else:
		animationLv1.hide()
		animationLv2.hide()
		animationLv3.show()
		currentAnimation = animationLv3
		currentAnimation.flip_h = animationLv2.flip_h

	currentAnimation.animation = "idle"
	if demoMode:
		currentAnimation.frames.set_animation_loop(currentAnimation.animation, true)


func initFullUnitName():
	if currentLevel == 1:
		fullUnitName = level1NamePrefix + unitName
	elif currentLevel == 2:
		fullUnitName = level2NamePrefix + unitName
	else:
		fullUnitName = level3NamePrefix + unitName
