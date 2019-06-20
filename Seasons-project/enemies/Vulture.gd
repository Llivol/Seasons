extends FlyPatroller

func _ready():
	set_stats(Global.HEALTH_AVERAGE, Global.SIZE_AVERAGE, Global.SPEED_SLOW, Global.DAMAGE_AVERAGE, true, Global.AS_SLOW)
	set_sprite_size()
	set_fly_time(Global.FLY_TIME_HIGH)