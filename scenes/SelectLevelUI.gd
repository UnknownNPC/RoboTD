extends Control


func _ready():
	for levelElement in levels:
		var levelBtn = levelBtnExample.duplicate()
		levelBtn.show()
		levelBtn.text = levelElement
		levelBtnsGrid.add_child(levelBtn)

		levelBtn.connect("pressed", self, "_levelBtnPress", [levels[levelElement]])


func _levelBtnPress(levelSceneUrl):
	get_tree().change_scene(levelSceneUrl)
