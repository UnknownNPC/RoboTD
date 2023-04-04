extends Node2D

onready var animationPlayer = $AnimationPlayer


func showWarn():
	if !animationPlayer.is_playing():
		animationPlayer.play("showWarn")
