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

onready var animation = $Animation

var currentLevel = 1
var maxLevel = 3

func _ready():
	attackRadiusShape.init(attackRadius)

func _on_SelectSprite_input_event(viewport, event, shape_idx):
	if (event.is_pressed()):
		
		$"/root/ScreenUISingleton"._resetUi()
		
		spriteSelect.show()
		$"/root/ScreenUISingleton".addInfoPanel(self)
		$"/root/ScreenUISingleton".addTowerSelectPanel(self)
		attackRadiusShape.show()
		
func _towerLevelWasIncreased():
	currentLevel += 1
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
