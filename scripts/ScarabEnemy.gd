extends "res://scripts/BaseEnemy.gd"

class_name ScarabEnemy


func _ready():
	var clickShape = CircleShape2D.new()
	clickShape.set_radius(10)
	selectShapeCollision.set_shape(clickShape)
