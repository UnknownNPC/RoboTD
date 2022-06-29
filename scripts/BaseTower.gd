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
	attackRadiusIntance = attackRadiusCircleScene.instance()
	attackRadiusIntance.attackRadius = attackRadius
	attackRadiusIntance.visible = false
	add_child(attackRadiusIntance)

func _on_SelectSprite_input_event(viewport, event, shape_idx):
	if (event.is_pressed()):
		print("Rendering tower UI elements")
		spriteSelect.visible = true
		attackRadiusIntance.visible = true
		$"/root/Utils".addInfoPanel(self)
		$"/root/Utils".addTowerSelectPanel(self)
		
func _towerLevelWasIncreased():
	currentLevel += 1
	$"/root/Utils".initTowerSelectPanel(self)

func _towerWasRemoved():
	queue_free()
