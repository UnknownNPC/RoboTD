extends Area2D

onready var selectSprite = $SelectSprite/Select
onready var selectShapeCollision = $SelectSprite/Collision
onready var spawnAnimation = $SpawnAnimation
onready var spawnPlayerSound = $SpawnPlayer
onready var nodeHighlight = $NodeHighlight

onready var towersNode = get_tree().get_root().find_node("Towers", true, false)


func _ready():
	var clickShape = RectangleShape2D.new()
	clickShape.set_extents(Vector2(16, 16))
	selectShapeCollision.set_shape(clickShape)


func _on_SelectSprite_input_event(_viewport, event, _shape_idx):
	if event.is_pressed():
		selfSelect()


func _towerBuy(resourcePath):
	var newTower = load(resourcePath).instance()
	newTower.global_position = self.global_position
	newTower.hide()
	$"/root/ScreenUISingleton"._resetUi()
	$"/root/LevelProcessState".getEnergy(newTower.buyCost)

	spawnPlayerSound.play()
	spawnAnimation.play("spawn")
	yield(spawnAnimation, "animation_finished")
	spawnAnimation.stop()

	towersNode.add_child(newTower)
	newTower.show()

	queue_free()


func selfSelect():
	$"/root/ScreenUISingleton"._resetUi()
	var buyMenuUi = $"/root/ScreenUISingleton".addBuyTowerMenuPanel()
	buyMenuUi.connect("towerBuy", self, "_towerBuy")
	selectSprite.visible = true
