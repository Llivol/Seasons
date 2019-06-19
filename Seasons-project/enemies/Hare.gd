extends LandPatroller

func _ready():
	set_stats(Global.HEALTH_LOW, Global.SIZE_AVERAGE, Global.SPEED_AVERAGE, Global.DAMAGE_LOW, true)
	set_sprite_size()