extends "res://scripts/BaseEnemy.gd"

onready var baseLevelSpawnBox = get_tree().get_root().find_node("RuntimeSpawnBox", true, false)

var eggEnemySceneUrl = "res://scenes/enemies/EggEnemy.tscn"

class_name ArahnaEnemy


func _ready():
	var clickShape = CircleShape2D.new()
	clickShape.set_radius(10)
	selectShapeCollision.set_shape(clickShape)


func dieSideEffects():
	var eggEnemy = load(eggEnemySceneUrl).instance()
	var eggEnemy2 = load(eggEnemySceneUrl).instance()
	eggEnemy.position = Vector2(position.x + 8, position.y)
	eggEnemy2.position = Vector2(position.x - 8, position.y)
	addEnemyToBaseLevel(eggEnemy)
	addEnemyToBaseLevel(eggEnemy2)


#should be moved to base level
func addEnemyToBaseLevel(enemy):
	var arahnaFollow = get_parent()

	var new_follow = PathFollow2D.new()
	new_follow.rotate = false
	new_follow.loop = false
	new_follow.add_child(enemy)
	new_follow.offset = arahnaFollow.offset

	var arahnaPath = get_parent().get_parent()

	var new_path = Path2D.new()
	new_path.position = arahnaPath.position
	new_path.curve = arahnaPath.curve
	new_path.add_child(new_follow)

	baseLevelSpawnBox.add_child(new_path)
