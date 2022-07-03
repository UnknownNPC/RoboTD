extends Area2D

onready var spriteSelect = $SelectSprite/Select
onready var spriteShape = $SelectSprite/Collision

onready var towersNode = $"/root/BaseLevel/Towers"

func _ready():
	spriteSelect.scale = Vector2(1, 1)
	var clickShape = RectangleShape2D.new()
	clickShape.set_extents(Vector2(16,16))
	spriteShape.set_shape(clickShape)

func _on_SelectSprite_input_event(viewport, event, shape_idx):
	if (event.is_pressed()):
		$"/root/ScreenUISingleton"._resetUi()
		var buyMenuUi = $"/root/ScreenUISingleton".addBuyTowerMenuPanel()
		buyMenuUi.connect("towerBuy", self, "_towerBuy")
		spriteSelect.visible = true

func _towerBuy(resourcePath):
	var newTower = load(resourcePath).instance()
	newTower.global_position = self.global_position
	towersNode.add_child(newTower)
	$"/root/GameProcessState".getEnergy(newTower.buyCost)
	newTower.selfSelect()
	queue_free()
	
