extends KinematicBody2D

# Member variables
const GRAVITY = 2250 # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 1000
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 250
const STOP_FORCE = 5000
const JUMP_SPEED = 500
const JUMP_FORCE = 32000
const JUMP_MAX_AIRBORNE_TIME = 0.01

const SLIDE_STOP_VELOCITY = 0.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 0.0 # one pixel

enum PlayerStates {
	idle,		#0 	
	walk,		#1
	stop		#2
	jump,		#3
	fall		#4
	hang		#5
	hover		#6
	crouch		#7
	sneak		#8
	pull		#9
	climb		#10
	attack		#11
	hurt		#12
	die			#13
}

var _state
var _velocity
var _force

var _direction_to_twin

var _prev_jump_pressed = false
var _on_air_time = 100
var _on_rope_max_distance = false

func _init():
	self._state = PlayerStates.idle
	self._velocity = Vector2()
	self._force = Vector2()
	self._direction_to_twin = Vector2()

func get_state():
	
	match self._state:
		0: 
			return "idle"
		1: 
			return "walk"
		2: 
			return "stop"
		3: 
			return "jump"
		4: 
			return "fall"
		5:
			return "hang"
		6: 
			return "hover"
		7:
			return "crouch"
		8:
			return "sneak"
		9:
			return "pull"
		10:
			return "climb"
		11:
			return "attack"
		12:
			return "hurt"
		13: 
			return "die"


func set_force_gravity():
	self._force = Vector2(0, GRAVITY)

func get_velocity():
	return self._velocity

func get_force():
	return self._force

func set_direction_to_twin(direction_to_twin):
	self._direction_to_twin = direction_to_twin

func set_on_rope_max_distance(on_rope_max_distance):
	self._on_rope_max_distance = on_rope_max_distance

func find_state():
	if self._on_rope_max_distance:
		self._state = PlayerStates.hover
	elif is_on_floor():
		if self._velocity.x == 0:
				self._state = PlayerStates.idle
		else:
			self._state = PlayerStates.walk
	elif self._velocity.y >= 0:
		self._state = PlayerStates.fall
	else: 
		self._state = PlayerStates.jump


func process_kinematics(move_left, move_right, jump, delta):
	set_force_gravity()
	
	linear_velocity_x(move_left, move_right, delta)
	
	if is_on_floor():
		self._on_air_time = 0
	
	linear_velocity_y(jump, delta)
	
	self._velocity += self._force * delta
	
	find_state()
	
	if self._state == PlayerStates.hover:
		omg_what_a_tension()
		pass
	
	self._velocity = move_and_slide(self._velocity, Vector2.UP)

func omg_what_a_tension():
	var velocity_length = self._velocity.length()
	var velocity_x_origin = self._velocity.x
	var velocity_y_origin = self._velocity.y
	
	self._velocity.y *= 10
	
	# 1: Desc. velocity en tangent i tension
	var angle_between_rope_and_velocity = self._direction_to_twin.angle_to(self._velocity)
	var angle_between_rope_and_floor = self._direction_to_twin.angle()
	
	var v_tangent_lenght = self._velocity.length() * sin(angle_between_rope_and_velocity)
	var v_tension_lenght = self._velocity.length() * cos(angle_between_rope_and_velocity)
	
	if abs(v_tension_lenght) < 0.1:
		v_tension_lenght = 0
	if abs(v_tangent_lenght) < 0.1:
		v_tangent_lenght = 0
	
	# 2: Desc tension y tangent en .x i .y
	var v_tension = Vector2()
	var v_tangent = Vector2()
	
		# Oju que l'angle es invertit, diria. Potser hem de posar algo en negatiu
	v_tension.x = v_tension_lenght * cos(angle_between_rope_and_floor)
	v_tension.y = v_tension_lenght * sin(angle_between_rope_and_floor)
	
	v_tangent.x = v_tangent_lenght * -sin(angle_between_rope_and_floor)
	v_tangent.y = v_tangent_lenght * cos(angle_between_rope_and_floor)
	
	# 3: Comprovem angles
	var angle_tension = v_tension.angle()
	var angle_rope = self._direction_to_twin.angle()
	
	var angle = v_tension.angle_to(self._direction_to_twin)
	var angle_diff = abs(angle_tension - angle_rope)
	
	if abs(angle_tension - angle_rope) > 0.1 :
		v_tension = Vector2.ZERO
	
	# 4: Reconstruim V
	self._velocity.x = v_tension.x + v_tangent.x
	self._velocity.y = v_tension.y + v_tangent.y
	
	if abs(self._velocity.x) < 0.1:
		self._velocity.x = 0
	if abs(self._velocity.y) < 0.1:
		self._velocity.y = 0
	
	print ("tension")

func get_angle_in_first_quadrant(angle):
	while angle > PI/2:
		angle -= PI/2
	
	while angle < 0:
		angle += PI/2
	return angle

func linear_velocity_x(walk_left, walk_right, delta):
	self._state = PlayerStates.stop
	
	if walk_left:
		if self._velocity.x <= WALK_MIN_SPEED and self._velocity.x > -WALK_MAX_SPEED:
			self._force.x -= WALK_FORCE
			self._state = PlayerStates.walk
	elif walk_right:
		if self._velocity.x >= -WALK_MIN_SPEED and self._velocity.x < WALK_MAX_SPEED:
			self._force.x += WALK_FORCE
			self._state = PlayerStates.walk
	
	if self._state == PlayerStates.stop: 
		var vsign = sign(self._velocity.x)
		var vlen = abs(self._velocity.x)

		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0

		self._velocity.x = vlen * vsign
			
	#self._velocity += self._force * delta

func linear_velocity_y(jump, delta):
	if self._state == PlayerStates.fall:
		pass
	
	if self._on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not self._prev_jump_pressed and not self._state == PlayerStates.jump:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		self._velocity.y = -JUMP_SPEED
	
	self._on_air_time += delta
	self._prev_jump_pressed = jump

func _hover(delta):
	var angle_between_rope_and_normal = acos(_direction_to_twin.dot(Vector2.DOWN))
	
	var fg = GRAVITY
	var fp = fg * sin(angle_between_rope_and_normal)
	var aa = fp
	var a = aa / _direction_to_twin.length()
	var linear_acceleration = Vector2()
	linear_acceleration.x = aa * cos(angle_between_rope_and_normal)
	linear_acceleration.y = aa * sin(angle_between_rope_and_normal)
	self._force = linear_acceleration
	self._velocity = self._force * delta
	"""
	var F = Vector2()
	F.x = - self._force.length() * sin(angle_between_rope_and_normal) * cos(angle_between_rope_and_normal)
	F.y = - self._force.length() * sin(angle_between_rope_and_normal) * sin(angle_between_rope_and_normal)

	self._force = F * _direction_to_twin.length()

	self._velocity = self._force * delta
	"""
	pass