extends LandChaser

func _ready():
	set_stats(Global.HEALTH_HIGH, Global.SIZE_LARGE, Global.SPEED_SLOW, Global.DAMAGE_HIGH, true, Global.AS_SLOW, Global.AWARENESS_AVERAGE)
	set_sprite_size()