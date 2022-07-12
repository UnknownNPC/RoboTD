extends "res://scripts/BaseEnemy.gd"

var eggEnemySceneUrl = "res://scenes/enemies/EggEnemy.tscn"

class_name ArahnaEnemy


func _ready():
	selectSprite.scale = Vector2(0.6, 0.6)

	var clickShape = CircleShape2D.new()
	clickShape.set_radius(10)
	selectShapeCollision.set_shape(clickShape)

func dieSideEffects():
	var eggEnemy = load(eggEnemySceneUrl).instance()
	eggEnemy.global_position = self.global_position
	var pathFollow = get_parent()
	if pathFollow is PathFollow2D:
		pathFollow.add_child(eggEnemy)
