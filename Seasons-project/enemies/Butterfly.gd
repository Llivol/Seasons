extends FlyPatroller

func _ready():
	set_stats(Global.HEALTH_LOW, Global.SIZE_SMALL, Global.SPEED_SLOW, Global.DAMAGE_LOW, false)
	set_sprite_size()
	set_fly_time(4)