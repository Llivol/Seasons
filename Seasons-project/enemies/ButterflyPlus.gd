extends FlyPatroller

func _ready():
	set_stats(Global.HEALTH_LOW, Global.SIZE_TINY, Global.SPEED_AVERAGE, Global.DAMAGE_LOW, false, Global.AS_SLOW)
	set_sprite_size()
	set_fly_time(Global.TIME_HIGH)