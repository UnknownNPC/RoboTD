extends "res://scripts/BaseEnemy.gd"

onready var baseLevelSpawnBox = $"/root/BaseLevel/RuntimeSpawnBox"

var eggEnemySceneUrl = "res://scenes/enemies/EggEnemy.tscn"

class_name ArahnaEnemy


func _ready():
	selectSprite.scale = Vector2(0.6, 0.6)

	var clickShape = CircleShape2D.new()
	clickShape.set_radius(10)
	selectShapeCollision.set_shape(clickShape)

func dieSideEffects():
	var eggEnemy = load(eggEnemySceneUrl).instance()
	eggEnemy.position = position
	
	var selfPathFollow = get_parent()
	var runtimePathFollow = selfPathFollow.duplicate()
	runtimePathFollow.add_child(eggEnemy)
	
	var selfPath = selfPathFollow.get_parent()
	selfPath.add_child(runtimePathFollow)
