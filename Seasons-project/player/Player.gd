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
const JUMP_MAX_AIRBORNE_TIME = 0.01

const SLIDE_STOP_VELOCITY = 0.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 0.0 # one pixel

enum PlayerStates {
	idle,		#0
	walk,		#1
	jump,		#2
	hover		#3
	falling		#4
}

var _state
var _velocity
var _force

var _on_air_time = 100
var _prev_jump_pressed = false

func _init():
	self._state = 0
	self._velocity = Vector2()
	self._force = Vector2()


func set_state(state):
	self._state = state

func get_state():
	return self._state

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

func set_on_air_time(on_air_time):
	self._on_air_time = on_air_time

func get_on_air_time():
	return self._on_air_time

func set_prev_jump_pressed(prev_jump_pressed):
	self._prev_jump_pressed = prev_jump_pressed

func get_prev_jump_pressed():
	return self._prev_jump_pressed


func walk(walk_left, walk_right, delta):
	if _state == 3:
		return
	if walk_left:
		if self._velocity.x <= WALK_MIN_SPEED and self._velocity.x > -WALK_MAX_SPEED:
			self._force.x -= WALK_FORCE
			self._state = 1
	elif walk_right:
		if self._velocity.x >= -WALK_MIN_SPEED and self._velocity.x < WALK_MAX_SPEED:
			self._force.x += WALK_FORCE
			self._state = 1
	
	if self._state == 0:
		var vsign = sign(self._velocity.x)
		var vlen = abs(self._velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		self._velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	self._velocity += self._force * delta


func jump(jump, delta):
	if _state == 3:
		return
	if self._state == 2 and self._velocity.y > 0:
		# If falling, no longer jumping
		self._state = 4
	
	if self._on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not self._prev_jump_pressed and self._state != 2:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		self._velocity.y = -JUMP_SPEED
		self._state = 2
	
	self._on_air_time += delta
	self._prev_jump_pressed = jump