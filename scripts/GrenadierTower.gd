extends "res://scripts/AttackTower.gd"

var grenadeSceneUrl = "res://scenes/ammo/Grenade.tscn"
class_name GrenadierTower


func _ready():
	selectSprite.scale = Vector2(1.2, 1.2)

	var clickShape = CircleShape2D.new()
	clickShape.set_radius(16)
	selectShapeCollision.set_shape(clickShape)


func howToDamage():
	var attackPoint = Vector2(attackTarget.global_position.x, attackTarget.global_position.y)

	var grenade = load(grenadeSceneUrl).instance()
	grenade.scale = Vector2(1.2, 1.2)
	var direction = -1 if currentAnimation.flip_h else 1
	add_child(grenade)
	grenade.init(attackPoint, direction)
