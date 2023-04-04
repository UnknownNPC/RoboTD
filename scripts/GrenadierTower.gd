extends "res://scripts/AttackTower.gd"

var grenadeSceneUrl = "res://scenes/ammo/Grenade.tscn"
class_name GrenadierTower

### TODO crete abstract class for debuffers
export var effectType = "Slowness"
export var effectValue = 0.5
export var effectDurationSec = 2.5


func levelUpParams():
	effectValue += 0.1
	effectRadius += 5
	effectDurationSec += 0.2


func _ready():
	var clickShape = CircleShape2D.new()
	clickShape.set_radius(16)
	selectShapeCollision.set_shape(clickShape)


func howToDamage():
	var attackPoint = Vector2(attackTarget.global_position.x, attackTarget.global_position.y)

	var grenade = load(grenadeSceneUrl).instance()
	grenade.scale = Vector2(1.2, 1.2)
	var direction = -1 if currentAnimation.flip_h else 1
	add_child(grenade)
	grenade.initSmokeGranade(attackPoint, direction, effectValue, effectDurationSec, demoMode)
