extends Control

var enemy

onready var nameValue = $NameValue
onready var speedValue = $SpeedValue
onready var hpValue = $HPValue
onready var rewardValue = $RewardValue
onready var animation = $BaseInfoUI/Animation


func _process(delta):
	### can be queue_free
	if is_instance_valid(enemy):
		hpValue.text = str(enemy.maxHealth) + "/" + str(enemy.currentHealth)
		animation.animation = enemy.get_node("Animation").animation
	else:
		## close
		queue_free()


func init(targetEnemy):
	enemy = targetEnemy
	nameValue.text = enemy.unitName
	speedValue.text = str(enemy.speed)
	rewardValue.text = str(enemy.energyReward)

	animation.frames = enemy.get_node("Animation").frames.duplicate()
	animation.animation = enemy.get_node("Animation").animation
	animation.scale = enemy.scale
