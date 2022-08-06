extends "res://scripts/BaseEnemy.gd"

class_name CentepideEnemy


func _ready():
	selectSprite.scale = Vector2(0.6, 0.6)

	var clickShape = RectangleShape2D.new()
	clickShape.extents = Vector2(27, 7)
	selectShapeCollision.set_shape(clickShape)
