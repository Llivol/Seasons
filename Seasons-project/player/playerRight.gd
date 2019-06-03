extends "res://player/Player.gd"

func _physics_process(delta):
	
	set_inputs(name)

	process_kinematics(delta)