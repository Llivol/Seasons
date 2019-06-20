extends LandPatroller

func _ready():
	set_stats(Global.HEALTH_HIGH, Global.SIZE_BIG, Global.SPEED_SLOW, Global.DAMAGE_HIGH, true, Global.AS_SLOW)
	set_sprite_size()