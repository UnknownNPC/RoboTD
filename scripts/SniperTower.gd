extends "res://scripts/AttackTower.gd"

# enables export var inheritence
class_name SniperTower


func _ready():
	selectSprite.scale = Vector2(1.2, 1.2)

	var clickShape = CircleShape2D.new()
	clickShape.set_radius(16)
	selectShapeCollision.set_shape(clickShape)
