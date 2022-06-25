extends Node

onready var basePath = $BaseWavePath

var enemyUrl = "res://scenes/enemies/SpiderEnemy.tscn"
var enemyInfoUrl = "res://scenes/GameUI.tscn"

var follows = []

var currentEnemyInfo = null

func _ready():
	
	var rawEnemy = load(enemyUrl)
	
	for i in range(1, 5):
		
		randomize()
		
		var lerpX = lerp(-30, 30, randf())
		var lerpY = lerp(-30, 30, randf())
		
		var enemy = rawEnemy.instance()
		enemy.connect("enemyClicked", self, "_enemyClicked")

		var new_follow = PathFollow2D.new()
		new_follow.rotate = false
		new_follow.loop = false
		new_follow.add_child(enemy)
		
		var new_path = Path2D.new()
		new_path.add_child(new_follow)
		var basePathPoints = basePath.curve.get_baked_points()
		for point in basePathPoints:
			new_path.curve.add_point(
				Vector2(
					point.x + lerpX,
					point.y + lerpY
				)
			)
		add_child(new_path)

		follows.append(new_follow)
	
func _process(delta):
	for follow in follows:
		var abstractEnemy = follow.get_child(0)
		if (is_instance_valid(abstractEnemy) && !abstractEnemy.isDead):
			follow.offset += abstractEnemy.speed * delta
			if follow.unit_offset >= 1:
				follow.queue_free()

func _enemyClicked(enemy):
	if (is_instance_valid(currentEnemyInfo)):
		currentEnemyInfo.queue_free()	
	currentEnemyInfo = _addEnemyInfo(enemy)
	
func _addEnemyInfo(enemy):
	var enemyInfo = load(enemyInfoUrl).instance()
	get_parent().add_child(enemyInfo)
	enemyInfo.init(enemy)
	return enemyInfo
