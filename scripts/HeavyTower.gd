extends "res://scripts/BaseTower.gd"

class_name HeavyTower

func _ready():
	selectSprite.scale = Vector2(1.4, 1.4)

	var clickShape = CircleShape2D.new()
	clickShape.set_radius(18)
	selectShapeCollision.set_shape(clickShape)
