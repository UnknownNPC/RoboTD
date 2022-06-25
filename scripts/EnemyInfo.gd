extends Control

var enemy
var viewEnemy

onready var nameValue = $NameValue
onready var speedValue = $SpeedValue
onready var hpValue = $HPValue
onready var unitPosition = $UnitPosition

func _process(delta):
	### can be queue_free
	if (is_instance_valid(enemy)):
		hpValue.text = str(enemy.maxHealth) + "/" + str(enemy.currentHealth)
		viewEnemy.get_node("Animation").animation = enemy.get_node("Animation").animation
	else:
		## close
		queue_free()
	
func init(targetEnemy):
	enemy = targetEnemy
	nameValue.text = enemy.unitName
	speedValue.text = str(enemy.speed)
	
	viewEnemy = targetEnemy.duplicate()
	viewEnemy.scale = Vector2(2,2)

	unitPosition.add_child(viewEnemy)

