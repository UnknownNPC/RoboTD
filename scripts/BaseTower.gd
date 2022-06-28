### Should be AFTER WAVE_SPAWNER
extends Node2D

export (int) var damageValue = 100
export (int) var attackRadius = 120
export (float) var attackCooldown = 1.0
export (String) var unitName

onready var spriteSelect = $SelectSprite/Select
onready var spriteShape = $SelectSprite/Collision

var attackRadiusCircleScene = preload("res://scenes/AttackRadiusCircle.tscn")
var attackRadiusIntance

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
