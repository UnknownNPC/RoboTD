extends Node2D

export (String) var unitName
export(int) var maxHealth = 100
export(int) var speed = 100
export(int) var energyReward = 10
var currentHealth = maxHealth

var isDead = false

signal rewardForKill(energy)

onready var heathBar = $HealthBar
onready var animation = $Animation
onready var deadBodyRelease = $DeadBodyRelease

onready var selectSprite = $SelectSprite/Select
onready var selectShapeCollision = $SelectSprite/Collision

onready var animationPlayer = $AnimationPlayer
onready var explosionAnimation = $ExplosionAnimation

func _ready():
	animation.animation = "walk"

func add_damage(damage):
	currentHealth = max(currentHealth - damage, 0)
	heathBar.update_healthbar(damage)
	if (currentHealth <= 0 && !isDead):

		#stop movement
		isDead = true
	
		#die animation time
		animation.animation = "die"
		
		#explosion
		explosionAnimation.play("small_explosion")

		emit_signal("rewardForKill", self.energyReward)
		animationPlayer.play("reward")
		deadBodyRelease.start()

func _on_DeadBodyRelease_timeout():
	queue_free()

func _on_SelectSprite_input_event2(viewport, event, shape_idx):
	if (event.is_pressed()):
		$"/root/ScreenUISingleton"._resetUi()
		selectSprite.visible = true
		$"/root/ScreenUISingleton".addInfoPanel(self)



func _on_ExplosionAnimation_animation_finished():
	explosionAnimation.hide()
