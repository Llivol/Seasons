extends LandChaser

func _ready():
	set_stats(Global.HEALTH_LOW, Global.SIZE_AVERAGE, Global.SPEED_FAST, Global.DAMAGE_AVERAGE, Global.AWARENESS_SMALL)
	set_sprite_size()