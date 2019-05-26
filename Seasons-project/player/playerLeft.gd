extends KinematicBody2D

var PlayerKinematics = load("res://player/PlayerKinematics.gd")

var kinematics = PlayerKinematics.new()

func _physics_process(delta):
	# Create forces
	kinematics.set_force_gravity()
	
	var walk_left = Input.is_action_pressed("move_left_p1")
	var walk_right = Input.is_action_pressed("move_right_p1")
	var jump = Input.is_action_pressed("jump_p1")
	
	#if kinematics.get_state() != 3:
	kinematics.set_state(0)
	
	kinematics.walk(walk_left, walk_right, delta)

	# Integrate velocity into motion and move
	var aux_velocity
	aux_velocity = move_and_slide(kinematics.get_velocity(), Vector2(0, -1))
	kinematics.set_velocity(aux_velocity)
	
	if is_on_floor():
		kinematics.set_on_air_time(0)
		
	kinematics.jump(jump, delta)

func _on_Rope_body_exited(body):
	print("body exited")
	if not body is KinematicBody2D:
		return
	print ("body is Player")
	body.kinematics.set_state(3)


func _on_Rope_body_entered(body):
	print("body entered")
	if not body is KinematicBody2D:
		return
	print ("body is Player")
	body.kinematics.set_state(0)
