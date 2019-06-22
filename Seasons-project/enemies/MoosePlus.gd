extends LandPatroller

func _ready():
	set_stats(Global.HEALTH_HIGH, Global.SIZE_LARGE, Global.SPEED_AVERAGE, Global.DAMAGE_HIGH, true, Global.AS_SLOW)
	set_sprite_size()