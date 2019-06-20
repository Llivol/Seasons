extends ClimbPatroller

func _ready() -> void:
	set_stats(Global.HEALTH_LOW, Global.SIZE_SMALL, Global.SPEED_AVERAGE, Global.DAMAGE_AVERAGE, false, Global.AS_SLOW)
	position = waypoints.get_start_position()
	target_position = waypoints.get_next_point_position()
	set_sprite_size()
	set_wait_time(1)