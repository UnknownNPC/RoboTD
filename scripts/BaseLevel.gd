extends Node

onready var spawnBox = $RuntimeSpawnBox
onready var nextWaveTimer = $NextWaveTriggerTimer
onready var nextEnemySpawnTimer = $NextEnemySpawn
onready var basePath = $BaseWavePath

var enemyUrl = "res://scenes/enemies/SpiderEnemy.tscn"

var paths = []
var isWaveWalking = true

var enemiesInWave = 5
var gameIsFinished = false

var spawnedEnemiesInWaveLeft = 0

onready var GAME_STATE = $"/root/GameProcessState"

func _ready():
	var maxWaveCounter = 20
	var healthCounter = 10
	var energyCounter = 0
	GAME_STATE.init(1, maxWaveCounter, healthCounter, energyCounter)
	spawnEnemies(enemiesInWave)
	
func _process(delta):
	if(gameIsFinished):
		print("Game over. Reloading")
		get_tree().reload_current_scene()
	else:
		var enemiesKilled = 0
		var enemiesPass = 0
		if (isWaveWalking and paths.size() > 0):
			for path in paths:
				var follow = path.get_child(0) if is_instance_valid(path) and path.get_child_count() > 0 else null
				var abstractEnemy = follow.get_child(0) if is_instance_valid(follow) and follow.get_child_count() > 0 else null
				if (is_instance_valid(abstractEnemy) and !abstractEnemy.isDead):
					follow.offset += abstractEnemy.speed * abstractEnemy.slownessModifier * delta
					if (follow.unit_offset >= 1):
						path.queue_free()
						### Enemy moved to the end
						GAME_STATE.dicreaseHealth()
						enemiesPass += 1
				else:
					###Enemy died and was removed
					enemiesKilled += 1

			if (GAME_STATE.healthCounter <= 0):
				print("Died")
				gameIsFinished = true
				return
			
			### All enemies were prcoessed
			if (paths.size() == enemiesKilled + enemiesPass):
				isWaveWalking = false
				if (GAME_STATE.currentWaveCounter == 
						GAME_STATE.maxWaveCounter):
					gameIsFinished = true
					return
				print("Waiting " + str(nextWaveTimer.wait_time) + " before next wave")
				nextWaveTimer.start()


func _on_NextWaveTriggerTimer_timeout():
	nextWaveTimer.stop()
	
	## bodies should be removed before next wave
	_cleanupWaveResources()
	
	#Prepare next wave
	GAME_STATE.increaseCurrentWave()
	enemiesInWave += 1
	print("Starting new wave with " + str(enemiesInWave) + " enemies")
	spawnEnemies(enemiesInWave)
	isWaveWalking = true

func spawnEnemies(count):
	spawnedEnemiesInWaveLeft = count
	print("Start enemies spawning")
	nextEnemySpawnTimer.start()

func _processRewardForKill(rewardCount):
	GAME_STATE.addEnergy(rewardCount)

#Should be run when stopProcessingMovement = true
func _cleanupWaveResources():
			for path in paths:
				if (is_instance_valid(path)):
					path.queue_free()
			paths = []
			spawnedEnemiesInWaveLeft = 0

func _on_NextEnemySpawn_timeout():
	if (spawnedEnemiesInWaveLeft > 0):
		print("Spawning enemy #" + str(spawnedEnemiesInWaveLeft))
		var rawEnemy = load(enemyUrl)
	
		randomize()
		
		var lerpX = lerp(-10, 10, randf())
		var lerpY = lerp(-10, 10, randf())
		
		var enemy = rawEnemy.instance()
		enemy.connect("rewardForKill", self, "_processRewardForKill")

		var new_follow = PathFollow2D.new()
		new_follow.rotate = false
		new_follow.loop = false
		new_follow.add_child(enemy)
		
		var new_path = Path2D.new()
		new_path.position = basePath.position
		new_path.add_child(new_follow)

		var basePathPoints = basePath.curve.get_baked_points()
		for point in basePathPoints:
			var newPoint = Vector2(point.x + lerpX, point.y + lerpY )
			new_path.curve.add_point(newPoint)
		
		spawnBox.add_child(new_path)
		paths.append(new_path)
		spawnedEnemiesInWaveLeft -= 1
	else:
		print("Stop enemy spawning")
		nextEnemySpawnTimer.stop()
