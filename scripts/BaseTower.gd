### Should be AFTER WAVE_SPAWNER
extends Node2D

export (int) var damageValue = 100
export (int) var attackRadius = 120
export (float) var attackCooldown = 1.0
export (String) var unitName

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
	updateCurrentAnimationByCurrentLevel()
	attackRadiusShape.init(attackRadius)

func _on_SelectSprite_input_event(viewport, event, shape_idx):
	if (event.is_pressed()):
		spriteSelect.show()
		$"/root/ScreenUISingleton".addInfoPanel(self)
		$"/root/ScreenUISingleton".addTowerSelectPanel(self)
		attackRadiusShape.show()
		
func _towerLevelWasIncreased():
	currentLevel += 1
	updateCurrentAnimationByCurrentLevel()
	levelUpParams()
	$"/root/ScreenUISingleton".initTowerSelectPanel(self)
	$"/root/ScreenUISingleton".addInfoPanel(self)
	attackRadiusShape.init(attackRadius)
	attackRadiusShape.show()

func _towerWasRemoved():
	queue_free()

func levelUpParams():
	damageValue += 5
	attackRadius += 10
	attackCooldown -= 0.1
	
func updateCurrentAnimationByCurrentLevel():
	if (currentLevel == 1):
		currentAnimation = animationLv1
	elif (currentLevel == 2):
		currentAnimation = animationLv2
	else:
		currentAnimation = animationLv2
