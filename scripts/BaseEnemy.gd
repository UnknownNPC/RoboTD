extends Node2D

export(String) var unitName
export(int) var maxHealth = 100
export(int) var speed = 100
export(int) var energyReward = 10
export(bool) var demoMode = false
var currentHealth
var slownessModifier = 1

var isDead = false

onready var heathBar = $HealthBar
onready var animation = $Animation
onready var deadBodyRelease = $DeadBodyRelease

onready var selectSprite = $SelectSprite/Select
onready var selectShapeCollision = $SelectSprite/Collision

onready var animationPlayer = $AnimationPlayer
onready var apRewardContainer = $AP_Reward
onready var rewardPopupValue = $AP_Reward/RewardValue

onready var explosionAnimation = $ExplosionAnimation
onready var incomeDamageAnimation = $IncomeDamageAnimation

onready var diePlayer = $DiePlayer
onready var diePlayer2 = $DiePlayer2
onready var diePlayer3 = $DiePlayer3
var random = RandomNumberGenerator.new()


func _ready():
	# fix reward scale size
	rewardPopupValue.text = str(energyReward)
	currentHealth = maxHealth
	animation.animation = "walk"
	if demoMode:
		selectSprite.queue_free()
		selectShapeCollision.queue_free()

	random.randomize()


func _process(_delta):
	# fix award modal scale when enemy dies
	if is_instance_valid(apRewardContainer) and is_instance_valid(self):
		apRewardContainer.scale = apRewardContainer.scale / self.scale


func add_damage(damage):
	currentHealth = max(currentHealth - damage, 0)
	heathBar.update_healthbar(damage)
	if currentHealth <= 0 && !isDead:
		#stop movement
		isDead = true

		# sound
		if !demoMode:
			var dieSoundIndex = random.randi_range(0, 2)
			match dieSoundIndex:
				0:
					diePlayer.play()
				1:
					diePlayer2.play()
				2:
					diePlayer3.play()

		#die animation time
		animation.animation = "die"

		#explosion
		var explosionAnimationName = getExplosion()
		explosionAnimation.play(explosionAnimationName)
		incomeDamageAnimation.play("big-fragments")
		incomeDamageAnimation.frame = 0

		addRewardForKill(self.energyReward)
		animationPlayer.play("reward")

		## some actions
		dieSideEffects()

		deadBodyRelease.start()
	else:
		incomeDamageAnimation.animation = getIncomeDamageAnimation()
		incomeDamageAnimation.frame = 0


func addRewardForKill(rewardCount):
	$"/root/LevelProcessState".addEnergy(rewardCount)


func dieSideEffects():
	pass


func getExplosion():
	return "small_explosion"


func getIncomeDamageAnimation():
	return "small-fragments"


func _on_DeadBodyRelease_timeout():
	queue_free()


func _on_SelectSprite_input_event2(_viewport, event, _shape_idx):
	if event.is_pressed():
		$"/root/ScreenUISingleton"._resetUi()
		selectSprite.visible = true
		$"/root/ScreenUISingleton".addInfoPanel(self)


func _on_ExplosionAnimation_animation_finished():
	explosionAnimation.hide()
