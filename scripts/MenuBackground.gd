extends Node2D

onready var back1Sample = preload("res://scenes/Background_1_Sample.tscn")
onready var back2Sample = preload("res://scenes/Background_2_Sample.tscn")
onready var main = $"."

var back1Var = null
var back2Var = null

var back_speed = 10


func _ready():
	back1Var = back1Sample.instance()
	back2Var = back2Sample.instance()
	main.add_child(back1Var)
	main.add_child(back2Var)


func _process(delta):
	back1Var.global_position.y += back_speed * delta
	back2Var.global_position.y += back_speed * delta

	var screen_height = get_viewport().get_visible_rect().size.y

	if back1Var.position.y >= screen_height:
		back1Var.queue_free()
		back1Var = back1Sample.instance()
		back1Var.position.y = -screen_height
		main.add_child(back1Var)
	elif back2Var.position.y >= screen_height:
		back2Var.queue_free()
		back2Var = back2Sample.instance()
		back2Var.position.y = -screen_height
		main.add_child(back2Var)
