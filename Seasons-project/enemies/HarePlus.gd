extends LandPatroller

func _ready():
	set_stats(Global.HEALTH_LOW, Global.SIZE_AVERAGE, Global.SPEED_FAST, Global.DAMAGE_AVERAGE, true, Global.AS_AVERAGE)
	set_sprite_size()