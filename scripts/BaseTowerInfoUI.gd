extends Control

var tower

onready var rankValue = $RankValue
onready var animation = $BaseInfoUI/Animation


func getPercentFromFloat(val: float):
	return str(val * 100) + "%"


func _process(delta):
	if is_instance_valid(tower):
		var targetAnimation = tower.currentAnimation.animation
		animation.animation = targetAnimation
		animation.frames.set_animation_loop(targetAnimation, true)


func init(targetTower):
	tower = targetTower
	rankValue.text = tower.fullUnitName

	animation.frames = tower.currentAnimation.frames.duplicate()
	animation.animation = tower.currentAnimation.animation
	animation.scale = Vector2(3, 3)
