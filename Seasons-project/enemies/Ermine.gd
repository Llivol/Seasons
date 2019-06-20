extends ClimbChaser

func _ready() -> void:
	set_stats(Global.HEALTH_LOW, Global.SIZE_AVERAGE, Global.SPEED_FAST, Global.DAMAGE_LOW, false, Global.AS_FAST, Global.AWARENESS_AVERAGE)
	position = waypoints.get_start_position()
	target_position = waypoints.get_next_point_position()
	set_sprite_size()
	set_wait_time(Global.WAIT_TIME_LOW)