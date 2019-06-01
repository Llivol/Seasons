extends "res://player/Player.gd"

func _physics_process(delta):
	var walk_left = Input.is_action_pressed("playerRight_left")
	var walk_right = Input.is_action_pressed("playerRight_right")
	var jump = Input.is_action_pressed("playerRight_up")

	process_kinematics(walk_left, walk_right, jump, delta)