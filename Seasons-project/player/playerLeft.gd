extends Player

func _ready():
	set_stats(Global.SIZE_AVERAGE)
	set_colors(Global.COLOR_GREEN, Global.COLOR_DARK_GREEN)


func _physics_process(delta):
	
	set_inputs(name)

	process_kinematics(delta)