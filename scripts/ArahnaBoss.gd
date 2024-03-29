extends "res://scripts/BaseEnemy.gd"

onready var baseLevelSpawnBox = get_tree().get_root().find_node("RuntimeSpawnBox", true, false)

var eggEnemySceneUrl = "res://scenes/enemies/EggEnemy.tscn"

class_name ArahnaBoss


func _ready():
	var clickShape = CircleShape2D.new()
	clickShape.set_radius(8)
	selectShapeCollision.set_shape(clickShape)


func dieSideEffects():
	var eggEnemy = load(eggEnemySceneUrl).instance()
	var eggEnemy2 = load(eggEnemySceneUrl).instance()
	var eggEnemy3 = load(eggEnemySceneUrl).instance()
	var eggEnemy4 = load(eggEnemySceneUrl).instance()
	eggEnemy.position = Vector2(position.x + 8, position.y)
	eggEnemy2.position = Vector2(position.x - 8, position.y)
	eggEnemy3.position = Vector2(position.x, position.y - 8)
	eggEnemy4.position = Vector2(position.x, position.y + 8)
	addEnemyToBaseLevel(eggEnemy)
	addEnemyToBaseLevel(eggEnemy2)
	addEnemyToBaseLevel(eggEnemy3)
	addEnemyToBaseLevel(eggEnemy4)


#should be moved to base level
func addEnemyToBaseLevel(enemy):
	var arahnaFollow = self.get_parent()

	var new_follow = PathFollow2D.new()
	new_follow.rotate = false
	new_follow.loop = false
	new_follow.add_child(enemy)
	new_follow.offset = arahnaFollow.offset

	var arahnaPath = self.get_parent().get_parent()

	var new_path = Path2D.new()
	new_path.position = arahnaPath.position
	new_path.curve = arahnaPath.curve
	new_path.add_child(new_follow)
	#You cannot add new Area2Ds to a scene during a call of another Area2Ds on_area_entered()
	baseLevelSpawnBox.call_deferred("add_child", new_path)
