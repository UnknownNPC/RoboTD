extends Node2D

export(int) var maxHealth = 100
export(int) var speed = 100
var currentHealth = maxHealth

var isDead = false

onready var heathBar = $HealthBar
onready var animation = $Animation
onready var deadBodyRelease = $DeadBodyRelease

func _ready():
	animation.animation = "walk"

func add_damage(damage):
	currentHealth -= damage
	heathBar.update_healthbar(damage)
	if (currentHealth <= 0 && !isDead):
		animation.animation = "die"
		isDead = true
		deadBodyRelease.start()

func _on_DeadBodyRelease_timeout():
	queue_free()
