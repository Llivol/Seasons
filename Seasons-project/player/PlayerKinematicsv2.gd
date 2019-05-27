extends Node

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
	run			#2
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
var _direction

var _prev_jump_pressed = false
var _on_air_time = 100
var _on_floor = false
var _on_rope_max_distance = false

func _init():
	self._state = PlayerStates.idle
	self._velocity = Vector2()
	self._force = Vector2()
	self._direction = Vector2()


func set_state(state):
	self._state = PlayerStates.values()[state]

func get_state():
	return self._state

func get_state_string():
	
	match self._state:
		0: 
			return "idle"
		1: 
			return "walk"
		2: 
			return "run"
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

func set_velocity(velocity):
	self._velocity = velocity

func get_velocity():
	return self._velocity

func set_force(force):
	self._force = force

func set_force_gravity():
	self._force = Vector2(0, GRAVITY)

func get_force():
	return self._force

func set_direction(direction):
	self._direction = direction

func get_direction():
	return self._direction

func set_prev_jump_pressed(prev_jump_pressed):
	self._prev_jump_pressed = prev_jump_pressed

func get_prev_jump_pressed():
	return self._prev_jump_pressed

func set_on_air_time(on_air_time):
	self._on_air_time = on_air_time

func get_on_air_time():
	return self._on_air_time

func set_on_floor(on_floor):
	self._on_floor = on_floor

func is_on_floor():
	return self._on_floor

func set_on_rope_max_distance(on_rope_max_distance):
	self._on_rope_max_distance = on_rope_max_distance

func get_on_rope_max_distance():
	return self._on_rope_max_distance


func find_state():
	if self._on_floor:
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
	match self._state:
		PlayerStates.idle:
			_idle()
			_walk(move_left, move_right, delta)
			_jump(jump, delta)
		PlayerStates.walk:
			_walk(move_left, move_right, delta)
			_jump(jump, delta)
		PlayerStates.jump:
			_walk(move_left, move_right, delta)
			_jump(jump, delta)
		PlayerStates.fall:
			_walk(move_left, move_right, delta)
			_fall(delta)
		PlayerStates.hover:
			_hover()
		_:
			print("Unknown state")

#TODO Rename variables
func _idle():
	pass


func _walk(walk_left, walk_right, delta):
	var is_walking_left = false
	var is_walking_right = false
	
	if walk_left:
		if self._velocity.x <= WALK_MIN_SPEED and self._velocity.x > -WALK_MAX_SPEED:
			self._force.x -= WALK_FORCE
			is_walking_left = true
	elif walk_right:
		if self._velocity.x >= -WALK_MIN_SPEED and self._velocity.x < WALK_MAX_SPEED:
			self._force.x += WALK_FORCE
			is_walking_right = true
	
	if !is_walking_left and !is_walking_right: 
		var vsign = sign(self._velocity.x)
		var vlen = abs(self._velocity.x)

		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0

		self._velocity.x = vlen * vsign
			
	self._velocity += self._force * delta


func _jump(jump, delta):
	if self._on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not self._prev_jump_pressed and self._state != 2:
		self._velocity.y = -JUMP_SPEED
		
	self._on_air_time += delta
	self._prev_jump_pressed = jump


func _fall(delta):
	self._on_air_time += delta
	self._prev_jump_pressed = true

func _hover():
	pass