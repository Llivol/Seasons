extends Enemy
class_name ClimbChaser

export var default_color = Global.COLOR_ORANGE
export var wait_time = 1 setget set_wait_time

onready var wait_timer: Timer = $Timer
onready var waypoints: = get_parent().get_node("Waypoints")

var target_position: = Vector2()
var just_collided: = false
var on_awarness_position


func _physics_process(delta):
	move(delta) if (not _target) else chase(delta, true)
	attack()


func _draw():
	if not Cheats.sprites:
		var n = 4
		var points_arc = PoolVector2Array()
		points_arc.push_back(Vector2.ZERO)
		var colors = PoolColorArray([default_color])
		
		for i in range(n + 1):
			var angle_point = deg2rad(i * 360 / n - 90)
			points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * SIZE)
		draw_polygon(points_arc, colors)


func set_wait_time(new_time):
	wait_time = new_time


""" Override """
func move(delta, flying = false, shooting = false):
	var direction: = (target_position - position).normalized()
	var velocity = min(abs(_velocity.length()) +  ACCELERATION, MAX_SPEED)
	var distance_to_target: = position.distance_to(target_position)

	_velocity = direction * velocity

	if distance_to_target < 2 :
		position = target_position
		_velocity = Vector2.ZERO
		if target_position == waypoints.get_start_position() and waypoints.is_clockwise():
			.flip_direction()
			waypoints.set_clockwise(not waypoints.is_clockwise())
		target_position = waypoints.get_next_point_position()
		set_physics_process(false)
		wait_timer.start()
	else:
		move_and_slide(_velocity)
		check_collisions()


""" Override """
func flip_direction():
	.flip_direction()
	waypoints.set_clockwise(not waypoints.is_clockwise())
	target_position = waypoints.get_next_point_position()


func check_collisions():
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "TileMap":
			if not just_collided:
				flip_direction()
				just_collided = true
				return

	just_collided = false


func _on_Timer_timeout() -> void:
	set_physics_process(true)