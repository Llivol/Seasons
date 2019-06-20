extends LandChaser

func _ready():
	set_stats(Global.HEALTH_AVERAGE, Global.SIZE_AVERAGE, Global.SPEED_FAST, Global.DAMAGE_HIGH, false, Global.AS_FAST, Global.AWARENESS_BIG)
	set_sprite_size()