extends Node

var currentLevelJson
var currentWave


func init(levelNum):
	var file = File.new()
	var jsonFilePath = "res://scenes/levels/LevelSettings_" + str(levelNum) + "_json.tres"
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


func setCurrentWave(currentWaveCount):
	currentWave = currentLevelJson["enemiesWave"][currentWaveCount - 1]


func getCurrentWaveEnemiesCount():
	return currentWave["count"]


func getCurrentWaveEnemiesSceneUrl():
	return currentWave["sceneUrl"]


func getCurrentWaveReward():
	return currentWave["reward"]
