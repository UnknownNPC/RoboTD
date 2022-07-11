extends Node

onready var spawnBox = $RuntimeSpawnBox
onready var nextWaveTimer = $NextWaveTriggerTimer
onready var nextEnemySpawnTimer = $NextEnemySpawn
onready var basePath = $BaseWavePath

var enableProcessing = true
var gameover = false

var paths = []
var spawnedEnemiesInWaveLeft = 0

onready var GAME_STATE = $"/root/GameProcessState"
onready var LEVEL_SETTINGS_READER = $"/root/LevelSettingsReader"


func _ready():
	LEVEL_SETTINGS_READER.init("1")

	GAME_STATE.init(
		LEVEL_SETTINGS_READER.getNumberOfWaves(),
		LEVEL_SETTINGS_READER.getHealthOnStart(),
		LEVEL_SETTINGS_READER.getEnergyOnStart()
	)
	spawnEnemies(LEVEL_SETTINGS_READER.getCurrentWaveEnemiesCount(GAME_STATE.currentWaveCounter))


func _process(delta):
	if gameover:
		print("Game over. Reloading")
		get_tree().reload_current_scene()
	else:
		var enemiesKilled = 0
		var enemiesPass = 0
		if enableProcessing and paths.size() > 0:
			for path in paths:
				var follow = (
					path.get_child(0)
					if is_instance_valid(path) and path.get_child_count() > 0
					else null
				)
				var abstractEnemy = (
					follow.get_child(0)
					if is_instance_valid(follow) and follow.get_child_count() > 0
					else null
				)
				if is_instance_valid(abstractEnemy) and !abstractEnemy.isDead:
					follow.offset += abstractEnemy.speed * abstractEnemy.slownessModifier * delta
					if follow.unit_offset >= 1:
						path.queue_free()
						### Enemy moved to the end
						GAME_STATE.dicreaseHealth()
						enemiesPass += 1
				else:
					###Enemy died and was removed
					enemiesKilled += 1

			if GAME_STATE.healthCounter <= 0:
				print("Died")
				gameover = true
				return

			### All enemies were prcoessed
			if paths.size() == enemiesKilled + enemiesPass:
				enableProcessing = false
				if GAME_STATE.currentWaveCounter == GAME_STATE.maxWaveCounter:
					gameover = true
					return
				print("Waiting " + str(nextWaveTimer.wait_time) + " before next wave")
				nextWaveTimer.start()

				var waveReward = LEVEL_SETTINGS_READER.getCurrentWaveReward(
					GAME_STATE.currentWaveCounter
				)
				GAME_STATE.addEnergy(waveReward)
				$"/root/ScreenUISingleton".showLevelBonusMenu(waveReward, nextWaveTimer)


func _on_NextWaveTriggerTimer_timeout():
	nextWaveTimer.stop()

	## bodies should be removed before next wave
	_cleanupWaveResources()

	#Prepare next wave
	GAME_STATE.increaseCurrentWave()

	var currentWaveEnemiesCount = LEVEL_SETTINGS_READER.getCurrentWaveEnemiesCount(
		GAME_STATE.currentWaveCounter
	)
	print("Starting new wave with " + str(currentWaveEnemiesCount) + " enemies")
	spawnEnemies(currentWaveEnemiesCount)
	enableProcessing = true


func spawnEnemies(enemiesCount):
	spawnedEnemiesInWaveLeft = enemiesCount
	print("Start enemies spawning")
	nextEnemySpawnTimer.start()


func _processRewardForKill(rewardCount):
	GAME_STATE.addEnergy(rewardCount)


#Should be run when stopProcessingMovement = true
func _cleanupWaveResources():
	for path in paths:
		if is_instance_valid(path):
			path.queue_free()
	paths = []
	spawnedEnemiesInWaveLeft = 0


func _on_NextEnemySpawn_timeout():
	if spawnedEnemiesInWaveLeft > 0:
		print("Spawning enemy #" + str(spawnedEnemiesInWaveLeft))
		var rawEnemy = load(
			LEVEL_SETTINGS_READER.getCurrentWaveEnemiesSceneUrl(GAME_STATE.currentWaveCounter)
		)

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
			var newPoint = Vector2(point.x + lerpX, point.y + lerpY)
			new_path.curve.add_point(newPoint)

		spawnBox.add_child(new_path)
		paths.append(new_path)
		spawnedEnemiesInWaveLeft -= 1
	else:
		print("Stop enemy spawning")
		nextEnemySpawnTimer.stop()
