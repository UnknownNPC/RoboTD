extends Node2D

export (String) var unitName
export(int) var maxHealth = 100
export(int) var speed = 100
var currentHealth = maxHealth

var isDead = false

onready var heathBar = $HealthBar
onready var animation = $Animation
onready var deadBodyRelease = $DeadBodyRelease

onready var spriteSelect = $SelectSprite/Select
onready var spriteShape = $SelectSprite/Collision

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


func _on_SelectSprite_input_event2(viewport, event, shape_idx):
	if (event.is_pressed()):
		$"/root/Utils".cleanupMouseSelection()
		spriteSelect.visible = true
		$"/root/Utils".addInfoPanel(self)

