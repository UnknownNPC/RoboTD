### Should be AFTER WAVE_SPAWNER
extends Node2D

export (int) var damageValue = 100
export (int) var attackRadius = 120
export (float) var attackCooldown = 1.0

var attackRadiusCircleScene = load("res://scenes/AttackRadiusCircle.tscn")

func _ready():
	var attackRadiusIntance = attackRadiusCircleScene.instance()
	attackRadiusIntance.attackRadius = attackRadius
	add_child(attackRadiusIntance)
