extends "res://scripts/BaseEnemy.gd"

class_name CentepideEnemy


onready var baseCollisionShape := $BaseCollisionShape

func _ready():
	var clickShape = RectangleShape2D.new()
	clickShape.extents = Vector2(26, 7)
	selectShapeCollision.set_shape(clickShape)
	
	selectShapeCollision.position = baseCollisionShape.position
