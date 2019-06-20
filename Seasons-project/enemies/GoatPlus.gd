extends ClimbPatroller

func _ready() -> void:
	set_stats(Global.HEALTH_AVERAGE, Global.SIZE_AVERAGE, Global.SPEED_FAST, Global.DAMAGE_AVERAGE, false, Global.AS_AVERAGE)
	position = waypoints.get_start_position()
	target_position = waypoints.get_next_point_position()
	set_sprite_size()
	set_wait_time(1)