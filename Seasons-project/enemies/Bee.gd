extends FlyChaser

func _ready():
	set_stats(Global.HEALTH_LOW, Global.SIZE_SMALL, Global.SPEED_AVERAGE, Global.DAMAGE_LOW, false, Global.AS_AVERAGE, Global.AWARENESS_SMALL)
	set_sprite_size()
	set_fly_time(Global.FLY_TIME_LOW)