extends "res://scripts/BaseEnemy.gd"

class_name CiclopeBoss


func _ready():
	var clickShape = CircleShape2D.new()
	clickShape.set_radius(8)
	selectShapeCollision.set_shape(clickShape)
