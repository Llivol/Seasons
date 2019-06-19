extends LandChaser

func _ready():
	set_stats(Global.HEALTH_AVERAGE, Global.SIZE_AVERAGE, Global.SPEED_AVERAGE, Global.DAMAGE_AVERAGE, false, Global.AWARENESS_BIG)
	set_sprite_size()