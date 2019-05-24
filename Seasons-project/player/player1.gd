extends KinematicBody2D

onready var player_constants = get_node("/root/PlayerConstants")

var velocity = Vector2()
var on_air_time = 100
var jumping = false

var prev_jump_pressed = false


func _physics_process(delta):
	# Create forces
	var force = Vector2(0, player_constants.GRAVITY)
	
	var walk_left = Input.is_action_pressed("move_left_p1")
	var walk_right = Input.is_action_pressed("move_right_p1")
	var jump = Input.is_action_pressed("jump_p1")
	
	var stop = true
	
	if walk_left:
		if velocity.x <= player_constants.WALK_MIN_SPEED and velocity.x > -player_constants.WALK_MAX_SPEED:
			force.x -= player_constants.WALK_FORCE
			stop = false
	elif walk_right:
		if velocity.x >= -player_constants.WALK_MIN_SPEED and velocity.x < player_constants.WALK_MAX_SPEED:
			force.x += player_constants.WALK_FORCE
			stop = false
	
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= player_constants.STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	velocity += force * delta	
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		on_air_time = 0
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if on_air_time < player_constants.JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -player_constants.JUMP_SPEED
		jumping = true
	
	on_air_time += delta
	prev_jump_pressed = jump
