extends FlyPatroller

func _ready():
	set_stats(Global.HEALTH_AVERAGE, Global.SIZE_BIG, Global.SPEED_SLOW, Global.DAMAGE_AVERAGE, true)
	set_sprite_size()
	set_fly_time(8)