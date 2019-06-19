extends LandShooter

func _ready():
	set_stats(Global.HEALTH_LOW, Global.SIZE_AVERAGE, Global.SPEED_AVERAGE, Global.DAMAGE_LOW, true, Global.AWARENESS_AVERAGE)
	set_shooter_stats(Global.DAMAGE_LOW, 1)
	can_attack = true
	set_sprite_size()