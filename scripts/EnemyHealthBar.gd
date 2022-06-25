extends Node2D

enum BarSize {SMALL, MEDIUM, LARGE}

var barRedSmall = preload("res://tiles/healths/health2.png")
var barYellowSmall = preload("res://tiles/healths/health1.png")
var barGreenSmall = preload("res://tiles/healths/health0.png")

var barRedMedium = preload("res://tiles/healths/health5.png")
var barYellowMedium = preload("res://tiles/healths/health4.png")
var barGreenMedium = preload("res://tiles/healths/health3.png")

var barRedLarge = preload("res://tiles/healths/health8.png")
var barYellowLarge = preload("res://tiles/healths/health7.png")
var barGreenLarge = preload("res://tiles/healths/health6.png")

var currentBarGreen
var currentBarYellow
var currentBarRed

var defaultValue = 100

onready var healthbar = $HealthBar

export (BarSize) var barSize = BarSize.SMALL

func _ready():
	hide()
	if get_parent() and get_parent().get("maxHealth"):
		healthbar.max_value = get_parent().get("maxHealth")
		healthbar.value = healthbar.max_value
	else:
		healthbar.max_value = defaultValue
		healthbar.value = defaultValue
	
	match barSize:
		BarSize.SMALL:
			currentBarGreen = barGreenSmall
			currentBarYellow = barYellowSmall
			currentBarRed = barRedSmall
			position = Vector2(9.0, -17.0)
		BarSize.MEDIUM:
			currentBarGreen = barGreenMedium
			currentBarYellow = barYellowMedium
			currentBarRed = barRedMedium
		BarSize.LARGE:
			currentBarGreen = barGreenLarge
			currentBarYellow = barYellowLarge
			currentBarRed = barRedLarge

	healthbar.texture_progress = currentBarGreen
		
		
func _process(delta):
	global_rotation = 0

func update_healthbar(value):
	show()
	healthbar.value -= value
	if healthbar.value < healthbar.max_value * 0.7:
		healthbar.texture_progress = currentBarYellow
	if healthbar.value < healthbar.max_value * 0.35:
		healthbar.texture_progress = currentBarRed
