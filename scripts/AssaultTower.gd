extends "res://scripts/BaseTower.gd"

onready var animation = $Animation
onready var attackTimer = $AttackTimer

var attackTarget = null
var canMakeShoot = true

func _ready():
	attackTimer.wait_time = attackCooldown
	animation.animation = "idle"
	spriteSelect.scale = Vector2(1.2, 1.2)

	var clickShape = CircleShape2D.new()
	clickShape.set_radius(16)
	spriteShape.set_shape(clickShape)
	

func _process(delta):
	
	### Attack
	if (!is_instance_valid(attackTarget)):
		var allEnemies = get_tree().get_nodes_in_group("enemies")
		for enemy in allEnemies:
			var isEnemyInsideRadius = isEnemyInsideAttackRadius(enemy)
			if  (!enemy.isDead && isEnemyInsideRadius):
				attackTarget = enemy
				break
			else:
				attackTarget = null
	else:
		var isEnemyStilInside = isEnemyInsideAttackRadius(attackTarget)
		if (!isEnemyStilInside || attackTarget.isDead):
			attackTarget = null
			return
		
		var isEmemyOnTheLeft = global_position.x - attackTarget.global_position.x > 0
		if (isEmemyOnTheLeft):
			animation.flip_h = true
		else:
			animation.flip_h = false

		# Shoot action
		if (canMakeShoot):
			animation.animation = "fire"
			animation.frame = 0
			
			attackTarget.add_damage(damageValue)
			attackTimer.start()
			canMakeShoot = false
	
	if (!is_instance_valid(attackTarget)):
		animation.animation = "idle"

func _on_AttackTimer_timeout():
	canMakeShoot = true

func isEnemyInsideAttackRadius(enemy):
	return pow((enemy.global_position.x - global_position.x),2) + pow((enemy.global_position.y - global_position.y),2) <= pow(attackRadius, 2)

