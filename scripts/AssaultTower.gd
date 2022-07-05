extends "res://scripts/BaseTower.gd"

# enables export var inheritence
class_name AssaultTower

func _ready():
	spriteSelect.scale = Vector2(1.2, 1.2)

	var clickShape = CircleShape2D.new()
	clickShape.set_radius(16)
	spriteShape.set_shape(clickShape)
