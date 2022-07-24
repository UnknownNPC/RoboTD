extends "res://scripts/AttackTower.gd"

var rocketSceneUrl = "res://scenes/ammo/Rocket.tscn"

class_name HeavyTower


func _ready():
	selectSprite.scale = Vector2(1.2, 1.2)

	var clickShape = CircleShape2D.new()
	clickShape.set_radius(16)
	selectShapeCollision.set_shape(clickShape)


func howToDamage():
	var attackPoint = Vector2(attackTarget.global_position.x, attackTarget.global_position.y)

	var rocket = load(rocketSceneUrl).instance()
	rocket.scale = Vector2(1.2, 1.2)
	rocket.connect("enemyInTheExplosionArea", self, "_enemyInTheExplosionArea")
	var direction = -1 if currentAnimation.flip_h else 1
	## should be spawned from the gun
	rocket.global_position.x = rocket.global_position.x + (15 if direction == 1 else -15)
	rocket.global_position.y = rocket.global_position.y - 7

	add_child(rocket)
	rocket.init(attackPoint, direction)


func _enemyInTheExplosionArea(enemy):
	enemy.add_damage(calcDamage())
