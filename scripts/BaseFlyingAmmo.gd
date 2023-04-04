extends Node2D

onready var animation = $Animation

var targetPoint = Vector2.ZERO
var direction = 1

var isFlying = false

var ammoSpeed = 1

var only_once = true

var isDemoMode = false


func init(initTargetPoint, initDirection, demoMode):
	targetPoint = initTargetPoint
	direction = initDirection
	animation.flip_h = false if direction == 1 else true
	isDemoMode = demoMode
	isFlying = true


func _process(delta):
	if isFlying:
		global_position = global_position.move_toward(targetPoint, ammoSpeed)

	if global_position.floor() == targetPoint.floor() and only_once:
		ammoAction()


func ammoAction():
	pass
