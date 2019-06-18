extends Enemy
class_name FlyChaser

export var default_color = Global.COLOR_ORANGE
export var fly_time = 2 setget set_fly_time

onready var ledge_detector = $LedgeDetector
onready var fly_timer = $FlyTimer


func _process(delta):
	if ledge_detector.is_near_wall():
		flip_direction()


func _draw():
	if not Cheats.sprites:
		var n = 3
		var points_arc = PoolVector2Array()
		points_arc.push_back(Vector2.ZERO)
		var colors = PoolColorArray([default_color])
	
		for i in range(n + 1):
			var angle_point = deg2rad(90 + i * 360 / n - 90)
			points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * SIZE)
		draw_polygon(points_arc, colors)


func _physics_process(delta):
	move(delta, true) if (not _target) else chase(delta, true, ledge_detector.is_near_floor())

func set_fly_time(new_time):
	fly_time = new_time

"""Override"""
func flip_direction():
	.flip_direction()
	fly_timer.start(fly_time)


func _on_FlyTimer_timeout():
	flip_direction()


func _on_AttackArea_body_entered(body):
	if body is Player:
		attack(body)


func _on_AwarenessArea_body_entered(body):
	if body is Player:
		_target = body
		_velocity = Vector2.ZERO
		flip_direction()


func _on_FocusArea_body_exited(body):
	if body is Player and body == _target:
		_target = null
		update_direction()
