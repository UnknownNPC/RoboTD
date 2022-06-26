### Should be AFTER WAVE_SPAWNER
extends Node2D

export (int) var damageValue = 100
export (int) var attackRadius = 120
export (float) var attackCooldown = 1.0
export (String) var unitName

var attackRadiusCircleScene = load("res://scenes/AttackRadiusCircle.tscn")

signal towerClicked(tower)

func _ready():
	var attackRadiusIntance = attackRadiusCircleScene.instance()
	attackRadiusIntance.attackRadius = attackRadius
	add_child(attackRadiusIntance)


func _on_ClickArea_input_event(viewport, event, shape_idx):
	if (event.is_pressed()):
		emit_signal("towerClicked", self)
