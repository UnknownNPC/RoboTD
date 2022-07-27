extends Node2D

onready var back1 = $Background_1
onready var back2 = $Background_2

var back_speed = 10


func _process(delta):
	back1.global_position.y += back_speed * delta
	back2.global_position.y += back_speed * delta

	var screen_height = get_viewport().get_visible_rect().size.y

	if back1.position.y >= screen_height:
		print("move back 1 to the top")
		back1.position.y = -screen_height
	elif back2.position.y >= screen_height:
		print("move back 2 to the top")
		back2.position.y = -screen_height
