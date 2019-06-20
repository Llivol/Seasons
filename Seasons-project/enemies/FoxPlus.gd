extends LandChaser

func _ready():
	set_stats(Global.HEALTH_LOW, Global.SIZE_AVERAGE, Global.SPEED_FAST, Global.DAMAGE_AVERAGE, false, Global.AS_FAST, Global.AWARENESS_AVERAGE)
	set_sprite_size()