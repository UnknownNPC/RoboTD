extends Node

onready var spawnBox = $RuntimeSpawnBox
onready var nextWaveTimer = $NextWaveTriggerTimer
onready var basePath = $BaseWavePath
onready var levelStateUI = $LevelStateUI

var enemyUrl = "res://scenes/enemies/SpiderEnemy.tscn"

var paths = []
var isWaveWalking = true

var currentWaveCounter = 1
var maxWaveCounter = 20
var healthCounter = 10
var energyCounter = 0

var enemiesInWave = 1
var levelIsFinished = false

func _ready():
	levelStateUI.init(healthCounter, maxWaveCounter, energyCounter)
	spawnEnemies(enemiesInWave)
	
func _process(delta):
	if(levelIsFinished):
		print("Game over")
		get_tree().reload_current_scene()
	else:
		var enemiesKilled = 0
		var enemiesPass = 0
		if (isWaveWalking):
			for path in paths:
				var follow = path.get_child(0) if is_instance_valid(path) and path.get_child_count() > 0 else null
				var abstractEnemy = follow.get_child(0) if is_instance_valid(follow) and follow.get_child_count() > 0 else null
				if (is_instance_valid(abstractEnemy)):
					if(!abstractEnemy.isDead):
						follow.offset += abstractEnemy.speed * delta
						if (follow.unit_offset >= 1):
							### Enemy moved to the end
							healthCounter -= 1
							levelStateUI.setHealth(healthCounter)
							enemiesPass += 1
				else:
					###Enemy died and was removed
					enemiesKilled += 1

			### All enemies were prcoessed
			if (paths.size() == enemiesKilled + enemiesPass):
				isWaveWalking = false
				_cleanupWaveResources()
				if (currentWaveCounter == maxWaveCounter):
					levelIsFinished = true
					return
				nextWaveTimer.start()
			
			if (healthCounter <= 0):
				print("Died")
				levelIsFinished = true
				return

func _on_NextWaveTriggerTimer_timeout():
	nextWaveTimer.stop()
	
	#Prepare next wave
	currentWaveCounter += 1
	levelStateUI.setWaveValue(currentWaveCounter)
	enemiesInWave += 1
	print("Starting new wave with " + str(enemiesInWave) + " enemies")
	spawnEnemies(enemiesInWave)
	isWaveWalking = true

func spawnEnemies(count):
	var rawEnemy = load(enemyUrl)
	
	for i in range(0, count):
		
		randomize()
		
		var lerpX = lerp(-30, 30, randf())
		var lerpY = lerp(-30, 30, randf())
		
		var enemy = rawEnemy.instance()
		enemy.connect("rewardForKill", self, "_processRewardForKill")

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
		spawnBox.add_child(new_path)

		paths.append(new_path)

func _processRewardForKill(rewardCount):
	energyCounter += rewardCount
	levelStateUI.setEnergy(energyCounter)

#Should be run when stopProcessingMovement = true
func _cleanupWaveResources():
			for path in paths:
				path.queue_free()
			paths = []
