extends Node2D

export (String) var unitName
export(int) var maxHealth = 100
export(int) var speed = 100
var currentHealth = maxHealth

signal enemyClicked(enemy)

var isDead = false

onready var heathBar = $HealthBar
onready var animation = $Animation
onready var deadBodyRelease = $DeadBodyRelease

onready var clickAreaBorder = $ClickArea/Select
onready var clickAreaShape = $ClickArea/Collision

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


func _on_ClickArea_input_event(viewport, event, shape_idx):
	if (event.is_pressed()):
		emit_signal("enemyClicked", self)
		$"/root/Utils".cleanupMouseSelection()
		clickAreaBorder.visible = true
