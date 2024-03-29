extends Node

var currentLevelJson


func init(levelNum):
	var file = File.new()
	var jsonFilePath = "res://scenes/levels/LevelSettings_" + str(levelNum) + ".json"
	file.open(jsonFilePath, file.READ)
	var text_json = file.get_as_text()
	var json = JSON.parse(text_json).result
	file.close()
	print("Loading level wave config file: " + str(json))
	currentLevelJson = json


func getEnergyOnStart():
	return currentLevelJson["energyOnStart"]


func getNumberOfWaves():
	return currentLevelJson["enemiesWave"].size()


func getHealthOnStart():
	return currentLevelJson["healthOnStart"]


func getCurrentWaveEnemiesCount(waveCount):
	return currentLevelJson["enemiesWave"][waveCount - 1]["count"]


func getCurrentWaveEnemiesSceneUrls(waveCount):
	return currentLevelJson["enemiesWave"][waveCount - 1]["scenes"]


func getCurrentWaveReward(waveCount):
	return currentLevelJson["enemiesWave"][waveCount - 1]["reward"]


func getSpawnIntervalSec(waveCount) -> float:
	return currentLevelJson["enemiesWave"][waveCount - 1]["spawnIntervalSec"]
