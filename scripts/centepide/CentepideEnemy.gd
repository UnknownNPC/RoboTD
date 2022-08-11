extends Node2D

onready var runtimeSpawnBox = $RuntimeSpawnBox
onready var containerEnemies = runtimeSpawnBox.get_children()

var isEnemyContainer = true
var pathToFollow = null


func _ready():
	for enemy in containerEnemies:
		if is_instance_valid(pathToFollow):
			pathToFollow.add_child(enemy)


func setPathToFollow(path):
	pathToFollow = path
