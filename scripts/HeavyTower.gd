extends "res://scripts/BaseTower.gd"

var rocketSceneUrl = "res://scenes/ammo/Rocket.tscn"

class_name HeavyTower

var attackPoint


func _ready():
	selectSprite.scale = Vector2(1.4, 1.4)

	var clickShape = CircleShape2D.new()
	clickShape.set_radius(16)
	selectShapeCollision.set_shape(clickShape)


func howToDamage():
	attackPoint = Vector2(attackTarget.global_position.x, attackTarget.global_position.y)

	var rocket = load(rocketSceneUrl).instance()
	rocket.scale = Vector2(1.2, 1.2)
	rocket.connect("rocketExplosion", self, "_rocketExplosion")
	var direction = -1 if currentAnimation.flip_h else 1
	add_child(rocket)
	rocket.init(attackPoint, direction)


func _rocketExplosion(radius):
	var allEnemies = get_tree().get_nodes_in_group("enemies")
	for enemy in allEnemies:
		if isEnemyInsideExplosionRadius(enemy, attackPoint, radius):
			enemy.add_damage(damageValue)


func isEnemyInsideExplosionRadius(enemy, targetPoint, radius):
	return (
		(
			pow(enemy.global_position.x - targetPoint.x, 2)
			+ pow(enemy.global_position.y - targetPoint.y, 2)
		)
		<= pow(radius, 2)
	)
