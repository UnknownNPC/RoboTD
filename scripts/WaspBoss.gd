extends "res://scripts/BaseEnemy.gd"

class_name WaspBoss


func _ready():
	var clickShape = CircleShape2D.new()
	clickShape.set_radius(5)
	selectShapeCollision.set_shape(clickShape)
