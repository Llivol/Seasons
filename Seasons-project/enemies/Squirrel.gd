extends LandShooter

func _ready():
	set_stats(Global.HEALTH_LOW, Global.SIZE_AVERAGE, Global.SPEED_AVERAGE, Global.DAMAGE_LOW, true, Global.AS_AVERAGE, Global.AWARENESS_AVERAGE)
	set_shooter_stats(Global.AS_AVERAGE, Global.SPEED_AVERAGE, Global.BULLET_SIZE_TINY, Global.DAMAGE_LOW, Global.COLOR_YELLOW)
	can_attack = true
	set_sprite_size()