extends Area2D

onready var spriteSelect = $SelectSprite/Select
onready var spriteShape = $SelectSprite/Collision

func _ready():
	spriteSelect.scale = Vector2(1, 1)
	var clickShape = RectangleShape2D.new()
	clickShape.set_extents(Vector2(16,16))
	spriteShape.set_shape(clickShape)

func _on_SelectSprite_input_event(viewport, event, shape_idx):
	if (event.is_pressed()):
		
		$"/root/ScreenUISingleton"._resetUi()
		
		print("rendering spawn point")
		spriteSelect.visible = true
#		$"/root/Utils".addInfoPanel(self)
