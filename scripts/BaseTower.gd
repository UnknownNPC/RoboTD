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

var attackRadiusCircleScene = preload("res://scenes/AttackRadiusCircle.tscn")
var attackRadiusIntance

var currentLevel = 1
var maxLevel = 3

func _ready():
	initRadius()

func _on_SelectSprite_input_event(viewport, event, shape_idx):
	if (event.is_pressed()):
		spriteSelect.visible = true
		attackRadiusIntance.visible = true
		$"/root/ScreenUISingleton".addInfoPanel(self)
		$"/root/ScreenUISingleton".addTowerSelectPanel(self)
		
func _towerLevelWasIncreased():
	currentLevel += 1
	levelUpParams()
	$"/root/ScreenUISingleton".initTowerSelectPanel(self)
	$"/root/ScreenUISingleton".addInfoPanel(self)
	initRadius()
	attackRadiusIntance.visible = true

func _towerWasRemoved():
	queue_free()

func levelUpParams():
	damageValue += 10
	attackRadius += 10
	attackCooldown -= 0.1

func initRadius():
	if (is_instance_valid(attackRadiusIntance)):
		attackRadiusIntance.queue_free()
	attackRadiusIntance = attackRadiusCircleScene.instance()
	attackRadiusIntance.attackRadius = attackRadius
	attackRadiusIntance.visible = false
	add_child(attackRadiusIntance)
