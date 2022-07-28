extends CanvasLayer

var levelsUrlPrefix := "res://scenes/levels/"
var levels := {"# 01": levelsUrlPrefix + "Level1.tscn", "# 02": levelsUrlPrefix + "Level2.tscn"}

onready var levelBtnExample = $SelectLevel/LevelsContainer/GridContainer/ButtonExample
onready var levelBtnsGrid = $SelectLevel/LevelsContainer/GridContainer

onready var gameMainMenu = $GameMainMenu
onready var selectLevel = $SelectLevel


func _ready():
	for level in levels:
		var selectLevelBtn = levelBtnExample.duplicate()
		selectLevelBtn.show()
		selectLevelBtn.text = level
		selectLevelBtn.connect("pressed", self, "_levelBtnClicked", [levels[level]])
		levelBtnsGrid.add_child(selectLevelBtn)


func _levelBtnClicked(levelSceneUrl):
	get_tree().change_scene_to(load(levelSceneUrl))


func _on_CampainBtn_pressed():
	gameMainMenu.hide()
	selectLevel.show()


func _on_GoBackBtn_pressed():
	# go back from campain page
	gameMainMenu.show()
	selectLevel.hide()
