extends Node2D

var barRedLarge = preload("res://tiles/healths/health8.png")
var barYellowLarge = preload("res://tiles/healths/health7.png")
var barGreenLarge = preload("res://tiles/healths/health6.png")

var currentBarGreen
var currentBarYellow
var currentBarRed

var defaultValue = 100

onready var healthbar = $HealthBar


func _ready():
	hide()
	if get_parent() and get_parent().get("maxHealth"):
		healthbar.max_value = get_parent().get("maxHealth")
		healthbar.value = healthbar.max_value
	else:
		healthbar.max_value = defaultValue
		healthbar.value = defaultValue

	currentBarGreen = barGreenLarge
	currentBarYellow = barYellowLarge
	currentBarRed = barRedLarge

	healthbar.texture_progress = currentBarGreen


func _process(_delta):
	global_rotation = 0


func update_healthbar(value):
	if value > 0:
		show()
		healthbar.value -= value
		if healthbar.value < healthbar.max_value * 0.7:
			healthbar.texture_progress = currentBarYellow
		if healthbar.value < healthbar.max_value * 0.35:
			healthbar.texture_progress = currentBarRed
