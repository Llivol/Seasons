extends FlyChaser

func _ready():
	set_stats(Global.HEALTH_AVERAGE, Global.SIZE_AVERAGE, Global.SPEED_SLOW, Global.DAMAGE_HIGH, true, Global.AS_SLOW, Global.AWARENESS_LARGE)
	set_sprite_size()
	set_fly_time(Global.TIME_VERY_HIGH)