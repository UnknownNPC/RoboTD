extends Node

var levelsUrlPrefix := "res://scenes/levels/"
var levels := {
	1: levelsUrlPrefix + "Level1.tscn",
	2: levelsUrlPrefix + "Level2.tscn",
	3: levelsUrlPrefix + "Level3.tscn",
	4: levelsUrlPrefix + "Level4.tscn",
	5: levelsUrlPrefix + "Level5.tscn",
	6: levelsUrlPrefix + "Level6.tscn",
	7: levelsUrlPrefix + "Level7.tscn",
	8: levelsUrlPrefix + "Level8.tscn",
	9: levelsUrlPrefix + "Level9.tscn",
	10: levelsUrlPrefix + "Level10.tscn"
}

var currentLevelId = null


func hasNextLevel():
	if currentLevelId != null:
		var nextLevel = currentLevelId + 1
		return levels.has(nextLevel)
	else:
		return false


func loadNextLevel():
	if hasNextLevel() and currentLevelId != null:
		var nextLevelId = currentLevelId + 1
		loadLevelById(nextLevelId)
	else:
		print("Invliad state. Can't load")


func getLevelNameById(levelId):
	return "%02d" % levelId


func loadLevelById(levelId):
	currentLevelId = levelId
	var sceneUrl = load(levels[currentLevelId])
	if get_tree().change_scene_to(sceneUrl) != OK:
		print("An unexpected error occured when trying to switch to the Readme scene")


func getLevels():
	return levels
