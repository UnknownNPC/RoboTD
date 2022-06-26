extends "res://scripts/BaseEnemy.gd"

func _ready():
	spriteSelect.scale = Vector2(0.6, 0.6)
	
	var clickShape = CircleShape2D.new()
	clickShape.set_radius(10)
	spriteShape.set_shape(clickShape)
