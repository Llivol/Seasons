extends FlyChaser

func _ready():
	set_stats(Global.HEALTH_LOW, Global.SIZE_SMALL, Global.SPEED_FAST, Global.DAMAGE_AVERAGE, false, Global.AS_AVERAGE, Global.AWARENESS_AVERAGE)
	set_sprite_size()
	set_fly_time(1)