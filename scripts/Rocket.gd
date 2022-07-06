extends Node2D

signal rocketExplosion(radius)

onready var animation = $Animation

export var damageRadius = 30

var fromPoint = Vector2.ZERO
var targetPoint = Vector2(100, 100)
var direction = 1

var isFlying = true

#lerp
var t = 0.0
var duration = 0.8

var only_once = true

func _ready():
	fromPoint = Vector2(global_position.x, global_position.y)

func init(initTargetPoint, initDirection):
	targetPoint = initTargetPoint
	direction = initDirection 
	

func _process(delta):
	if (isFlying):
		t += delta / duration
		global_position = lerp(fromPoint, targetPoint, min(t, 1.0))

	if (global_position.floor() == targetPoint.floor() and only_once):
		stop()

func stop():
	only_once = false
	isFlying = false

	emit_signal("rocketExplosion", damageRadius)
	animation.play("explosion")
	yield(animation, "animation_finished")
	queue_free()
	
