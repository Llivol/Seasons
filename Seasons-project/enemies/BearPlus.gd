extends LandChaser

func _ready():
	set_stats(Global.HEALTH_HIGH, Global.SIZE_BIG, Global.SPEED_AVERAGE, Global.DAMAGE_HIGH, true, Global.AS_SLOW, Global.AWARENESS_BIG)
	set_sprite_size()