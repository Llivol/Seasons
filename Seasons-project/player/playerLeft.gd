extends KinematicBody2D

var PlayerKinematics = load("res://player/PlayerKinematicsv2.gd")

var kinematics = PlayerKinematics.new()

func _physics_process(delta):
	var walk_left = Input.is_action_pressed("move_left_p1")
	var walk_right = Input.is_action_pressed("move_right_p1")
	var jump = Input.is_action_pressed("jump_p1")

	kinematics.process_kinematics(walk_left, walk_right, jump, delta)

	# Integrate velocity into motion and move
	kinematics.set_velocity(move_and_slide(kinematics.get_velocity(), Vector2(0, -1)))
	
	#TODO Aix es pot posar més maco
	if is_on_floor():
		kinematics.set_on_air_time(0)
		kinematics.set_on_floor(true)
	else:
		kinematics.set_on_floor(false)
	
	kinematics.find_state()