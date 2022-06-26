extends Control

var tower

onready var nameValue = $BaseInfoUI/NameValue
onready var damageValue = $DamageValue
onready var aRateValue = $ARateValue
onready var radiusValue = $RadiusValue
onready var animation = $BaseInfoUI/Animation

func _process(delta):
	if is_instance_valid(tower):
		var targetAnimation = tower.get_node("Animation").animation
		animation.animation = targetAnimation
		animation.frames.set_animation_loop(targetAnimation, true)

func init(targetTower):
	tower = targetTower
	nameValue.text = tower.unitName
	damageValue.text = str(tower.damageValue)
	aRateValue.text = str(tower.attackCooldown)
	radiusValue.text = str(tower.attackRadius)

	animation.frames = tower.get_node("Animation").frames.duplicate()
	animation.animation = tower.get_node("Animation").animation
	animation.scale = Vector2(3, 3)
