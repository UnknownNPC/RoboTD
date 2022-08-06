extends Area2D

onready var collision = $Collision

onready var selectContainer = $Select
onready var topLeftSprite = $Select/topLeft
onready var topRightSprite = $Select/topRight
onready var bottomLeftSprite = $Select/bottomLeft
onready var bottomRightSprite = $Select/bottomRight
onready var parentScaleVal = get_parent().scale if is_instance_valid(get_parent()) else Vector2.ONE

const DISTANCE_CONST = 1


func _ready():
	# wait that child set shape
	call_deferred("_initSelectBorders")


func _initSelectBorders():
	print(parentScaleVal)

	if is_instance_valid(collision.shape):
		var topRight = Vector2.ZERO
		var topLeft = Vector2.ZERO
		var bottomLeft = Vector2.ZERO
		var bottomRight = Vector2.ZERO

		var center = self.global_position

		if collision.shape is CircleShape2D:
			# correct scale
			var radius = collision.shape.radius * (parentScaleVal.x + parentScaleVal.y) / 2
			var hipotenuza = sqrt(pow(radius, 2) + pow(radius, 2))

			topRight = _movePointToLenghtAndAngle(45, hipotenuza + DISTANCE_CONST, center)
			topLeft = _movePointToLenghtAndAngle(135, hipotenuza + DISTANCE_CONST, center)
			bottomLeft = _movePointToLenghtAndAngle(225, hipotenuza + DISTANCE_CONST, center)
			bottomRight = _movePointToLenghtAndAngle(315, hipotenuza + DISTANCE_CONST, center)

		elif collision.shape is RectangleShape2D:
			var size = collision.shape.extents
			var hipotenuza = sqrt(pow(size.x, 2) + pow(size.y, 2))

			topRight = _movePointToLenghtAndAngle(45, hipotenuza + DISTANCE_CONST, center)
			topLeft = _movePointToLenghtAndAngle(135, hipotenuza + DISTANCE_CONST, center)
			bottomLeft = _movePointToLenghtAndAngle(225, hipotenuza + DISTANCE_CONST, center)
			bottomRight = _movePointToLenghtAndAngle(315, hipotenuza + DISTANCE_CONST, center)

		topLeftSprite.global_position = bottomLeft
		topRightSprite.global_position = bottomRight
		bottomLeftSprite.global_position = topLeft
		bottomRightSprite.global_position = topRight

		# correct sprite size
		topLeftSprite.scale = topLeftSprite.scale / parentScaleVal
		topRightSprite.scale = topRightSprite.scale / parentScaleVal
		bottomLeftSprite.scale = bottomLeftSprite.scale / parentScaleVal
		bottomRightSprite.scale = bottomRightSprite.scale / parentScaleVal


func _angle2Rad(angle: int):
	return angle * PI / 180


func _movePointToLenghtAndAngle(angle: int, d: float, point: Vector2):
	var angleToRadian = _angle2Rad(angle)
	return Vector2(point.x + (d * cos(angleToRadian)), point.y + (d * sin(angleToRadian)))
