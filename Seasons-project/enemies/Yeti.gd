extends LandShooter

func _ready():
	set_stats(Global.HEALTH_HIGH, Global.SIZE_BIG, Global.SPEED_SLOW, Global.DAMAGE_AVERAGE, Global.AWARENESS_AVERAGE)
	set_shooter_stats(Global.DAMAGE_HIGH, 2, 50, 16)
	can_attack = true
	set_sprite_size()