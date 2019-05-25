extends KinematicBody2D

var Player = load("res://player/Player.gd")

var player = Player.new()

func _physics_process(delta):
	# Create forces
	player.set_force_gravity()
	
	var walk_left = Input.is_action_pressed("move_left_p1")
	var walk_right = Input.is_action_pressed("move_right_p1")
	var jump = Input.is_action_pressed("jump_p1")
	
	player.set_state(0)
	
	player.walk(walk_left, walk_right, delta)

	# Integrate velocity into motion and move
	var aux_velocity
	aux_velocity = move_and_slide(player.get_velocity(), Vector2(0, -1))
	player.set_velocity(aux_velocity)
	
	if is_on_floor():
		player.set_on_air_time(0)
		
	player.jump(jump, delta)