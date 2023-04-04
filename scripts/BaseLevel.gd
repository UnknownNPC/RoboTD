extends Node

onready var spawnBox = $RuntimeSpawnBox
onready var nextWaveTimer = $NextWaveTriggerTimer
onready var nextEnemySpawnTimer = $NextEnemySpawn
onready var basePath = $BaseWavePath
onready var waveDirectionArrows = $WaveDirectionArrows
onready var enemyFinishedRoadSoundPlayer = $EnemyFinishedRoadSoundPlayer

var enableProcessing = false
var isAllLifesLeft = false
var isLevelCompleted = false

var spawnedEnemiesInWaveLeft := 0

onready var GAME_STATE := $"/root/LevelProcessState"
onready var LEVEL_SETTINGS_READER := $"/root/LevelSettingsReader"
onready var SCREEN_UI_MANAGER := $"/root/ScreenUISingleton"
onready var SAVE_MANAGER := $"/root/GameSaveService"
onready var MUSIC_PLAYER := $"/root/LevelMusicPlayer"

var firstWaveWaitingSec := 10.0
var regularWaveWaitingSec := 5.0

var alreadyOpenedEndGameModal = true


func _ready():
	MUSIC_PLAYER.playNextLevelMusic()
	LEVEL_SETTINGS_READER.init(levelNum())

	GAME_STATE.init(
		LEVEL_SETTINGS_READER.getNumberOfWaves(),
		LEVEL_SETTINGS_READER.getHealthOnStart(),
		LEVEL_SETTINGS_READER.getEnergyOnStart()
	)

	nextWaveTimer.wait_time = firstWaveWaitingSec
	nextWaveTimer.start()
	SCREEN_UI_MANAGER.showFirstWaveMenu(nextWaveTimer)


### should be overriden
func levelNum() -> int:
	return -999999


func _process(delta):
	if isAllLifesLeft and alreadyOpenedEndGameModal:
		print("Game over")
		SCREEN_UI_MANAGER.showGameOverModal()
		alreadyOpenedEndGameModal = false
	elif isLevelCompleted and alreadyOpenedEndGameModal:
		print("Level completed. Saving...")
		SAVE_MANAGER.saveLastLevelIfProgressHappens(levelNum())
		SCREEN_UI_MANAGER.showLevelCompleteModal()
		alreadyOpenedEndGameModal = false
	else:
		if enableProcessing:
			var allEnemies = get_tree().get_nodes_in_group("enemies")
			for enemy in allEnemies:
				if !enemy.isDead:
					var follow = enemy.get_parent() as PathFollow2D

					var enemyPosBeforeMove = enemy.global_position
					follow.offset += enemy.speed * enemy.slownessModifier * delta

					var angleBetweenPoints = rad2deg(
						enemyPosBeforeMove.angle_to_point(enemy.global_position)
					)
					# from 0 to 85 or 0 to -85
					if (
						(angleBetweenPoints >= 0 and angleBetweenPoints <= 85)
						or angleBetweenPoints <= 0 and angleBetweenPoints >= -85
					):
						enemy.animation.flip_h = true
					# from 95 to 175 or -95 to -175
					elif (
						(angleBetweenPoints >= 95 and angleBetweenPoints <= 175)
						or angleBetweenPoints <= -95 and angleBetweenPoints >= -175
					):
						enemy.animation.flip_h = false

					if follow.unit_offset >= 1:
						enemyFinishedRoadSoundPlayer.play()
						enemy.queue_free()
						### Enemy moved to the end
						GAME_STATE.dicreaseHealth()

			if GAME_STATE.healthCounter <= 0:
				print("Died")
				isAllLifesLeft = true
				return

			### All enemies were prcoessed
			if allEnemies.size() == 0:
				enableProcessing = false
				if GAME_STATE.currentWaveCounter == GAME_STATE.maxWaveCounter:
					isLevelCompleted = true
					return
				print("Waiting " + str(nextWaveTimer.wait_time) + " before next wave")
				nextWaveTimer.start()
				waveDirectionArrows.show()

				var waveReward = LEVEL_SETTINGS_READER.getCurrentWaveReward(
					GAME_STATE.currentWaveCounter
				)
				GAME_STATE.addEnergy(waveReward)
				SCREEN_UI_MANAGER.showLevelBonusMenu(waveReward, nextWaveTimer)


func _on_NextWaveTriggerTimer_timeout():
	nextWaveTimer.wait_time = regularWaveWaitingSec
	waveDirectionArrows.hide()

	## bodies should be removed before next wave
	_cleanupWaveResources()

	#Prepare next wave
	GAME_STATE.increaseCurrentWave()

	var currentWaveEnemiesCount = LEVEL_SETTINGS_READER.getCurrentWaveEnemiesCount(
		GAME_STATE.currentWaveCounter
	)
	var spawnInterval = LEVEL_SETTINGS_READER.getSpawnIntervalSec(GAME_STATE.currentWaveCounter)
	print(
		(
			"Starting new wave with "
			+ str(currentWaveEnemiesCount)
			+ " enemies in interval "
			+ str(spawnInterval)
		)
	)
	spawnEnemies(currentWaveEnemiesCount, spawnInterval)


func spawnEnemies(enemiesCount, spawnInterval):
	spawnedEnemiesInWaveLeft = enemiesCount
	print("Start enemies spawning")
	nextEnemySpawnTimer.wait_time = spawnInterval
	nextEnemySpawnTimer.start()


#Should be run when stopProcessingMovement = true
func _cleanupWaveResources():
	print("_cleanupWaveResources: cleanup spawnbox - " + str(spawnBox.get_child_count()))
	for child in spawnBox.get_children():
		child.queue_free()
	spawnedEnemiesInWaveLeft = 0


func _on_NextEnemySpawn_timeout():
	if spawnedEnemiesInWaveLeft > 0:
		randomize()

		var enemiesUrls = LEVEL_SETTINGS_READER.getCurrentWaveEnemiesSceneUrls(
			GAME_STATE.currentWaveCounter
		)

		var randomEnemyUrl = enemiesUrls[randi() % enemiesUrls.size()]
		print("Spawning enemy #" + str(spawnedEnemiesInWaveLeft) + ": " + randomEnemyUrl)

		var lerpX = lerp(-10, 10, randf())
		var lerpY = lerp(-10, 10, randf())

		var enemy = load(randomEnemyUrl).instance()

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
		spawnedEnemiesInWaveLeft -= 1

		## need to to trigger on the first spawn. but whatever
		enableProcessing = true
	else:
		print("Stop enemy spawning")
		nextEnemySpawnTimer.stop()
