extends "res://scripts/BufferTower.gd"


func _ready():
	var clickShape = CircleShape2D.new()
	clickShape.set_radius(16)
	selectShapeCollision.set_shape(clickShape)
