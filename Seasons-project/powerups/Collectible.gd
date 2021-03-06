extends Area2D

var SIZE

var default_color

func _ready():
	SIZE = Global.SIZE_TINY * 0.7
	$Shape.shape.set_radius(SIZE)
	default_color = Global.COLOR_YELLOW


func _draw():
	var n = 3
	var points_arc = PoolVector2Array()
	points_arc.push_back(Vector2.ZERO)
	var colors = PoolColorArray([default_color])

	for i in range(n + 1):
		var angle_point = deg2rad(i * 360 / n - 90)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * SIZE)
	draw_polygon(points_arc, colors)
	
	points_arc = PoolVector2Array()
	points_arc.push_back(Vector2.ZERO)

	for i in range(n + 1):
		var angle_point = deg2rad(180 + i * 360 / n - 90)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * SIZE)
	draw_polygon(points_arc, colors)


func _on_body_entered(body):
	queue_free()
