extends Node2D

export(float) var effectRadius


func init(effectRadiusVal):
	hide()
	effectRadius = effectRadiusVal


func _draw():
	draw_circle_donut_poly(Vector2.ZERO, effectRadius, effectRadius + 2, 0, 360, Color.darkcyan)


func draw_circle_donut_poly(center, inner_radius, outer_radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	var points_arc2 = PoolVector2Array()
	var colors = PoolColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - 90
		points_arc.push_back(
			center + Vector2(cos(deg2rad(angle_point)), sin(deg2rad(angle_point))) * outer_radius
		)
	for i in range(nb_points, -1, -1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - 90
		points_arc.push_back(
			center + Vector2(cos(deg2rad(angle_point)), sin(deg2rad(angle_point))) * inner_radius
		)
	draw_polygon(points_arc, colors)
