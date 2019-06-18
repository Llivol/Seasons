extends LandPatroller

func _ready():
	set_stats(Global.HEALTH_LOW, Global.SIZE_AVERAGE, Global.SPEED_SLOW, Global.DAMAGE_LOW)
	set_sprite_size()