extends Spawner

func _ready():
	set_stats(Global.SIZE_AVERAGE, Global.HEALTH_LOW, 0, true)
	set_spawner_stats("res://enemies/BeePlus.tscn", Global.TIME_AVERAGE, Global.AWARENESS_AVERAGE)