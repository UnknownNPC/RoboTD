extends Area2D

onready var selectSprite = $SelectSprite/Select
onready var selectShapeCollision = $SelectSprite/Collision

onready var towersNode = get_tree().get_root().find_node("Towers", true, false)

func _ready():
	selectSprite.scale = Vector2(1, 1)
	var clickShape = RectangleShape2D.new()
	clickShape.set_extents(Vector2(16, 16))
	selectShapeCollision.set_shape(clickShape)


func _on_SelectSprite_input_event(viewport, event, shape_idx):
	if event.is_pressed():
		selfSelect()

func _towerBuy(resourcePath):
	var newTower = load(resourcePath).instance()
	newTower.global_position = self.global_position
	towersNode.add_child(newTower)
	$"/root/GameProcessState".getEnergy(newTower.buyCost)
	newTower.selfSelect()
	queue_free()

func selfSelect():
		$"/root/ScreenUISingleton"._resetUi()
		var buyMenuUi = $"/root/ScreenUISingleton".addBuyTowerMenuPanel()
		buyMenuUi.connect("towerBuy", self, "_towerBuy")
		selectSprite.visible = true
