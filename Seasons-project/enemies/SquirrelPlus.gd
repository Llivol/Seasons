extends LandShooter

func _ready():
	set_stats(Global.HEALTH_LOW, Global.SIZE_AVERAGE, Global.SPEED_AVERAGE, Global.DAMAGE_LOW, true, Global.AS_FAST, Global.AWARENESS_LARGE)
	set_shooter_stats(Global.AS_AVERAGE, Global.SPEED_FAST, Global.BULLET_SIZE_TINY, Global.DAMAGE_LOW, Global.COLOR_ORANGE)
	can_attack = true
	set_sprite_size()