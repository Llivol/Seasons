extends KinematicBody2D
class_name Player
"""
onready var _transitions := {
	IDLE: [WALK, JUMP, FALL, HOVER, PULL, CLIMB, ATTACK, HURT, DIE],
	WALK: [IDLE, STOP, JUMP, FALL, HOVER, CLIMB, ATTACK, HURT, DIE],
	STOP: [IDLE, WALK],
	JUMP: [FALL, HANG, HOVER, HURT, DIE],
	FALL: [IDLE, HANG, HOVER, HURT, DIE],
	HANG: [IDLE, FALL, HOVER],
	HOVER: [IDLE, WALK, JUMP, FALL, HANG, CLIMB],
	CROUCH: [],
	SNEAK: [],
	PULL: [IDLE],
	CLIMB: [IDLE, FALL, HOVER, HANG],
	ATTACK: [IDLE, HOVER],
	HURT: [IDLE],
	DIE: [IDLE],
}
"""

onready var _transitions := {
	IDLE: [WALK, STOP, JUMP, FALL, HANG, HOVER, PULL, CLIMB, ATTACK, HURT, DIE],
	WALK: [IDLE, STOP, JUMP, FALL, HANG, HOVER, PULL, CLIMB, ATTACK, HURT, DIE],
	STOP: [IDLE, WALK, JUMP, FALL, HANG, HOVER, PULL, CLIMB, ATTACK, HURT, DIE],
	JUMP: [IDLE, WALK, STOP, FALL, HANG, HOVER, PULL, CLIMB, ATTACK, HURT, DIE],
	FALL: [IDLE, HANG, HOVER, HURT, DIE],
	HANG: [IDLE, WALK, STOP, JUMP, FALL, HOVER, PULL, CLIMB, ATTACK, HURT, DIE],
	HOVER: [IDLE, WALK, STOP, JUMP, FALL, HANG, PULL, CLIMB, ATTACK, HURT, DIE],
	CROUCH: [],
	SNEAK: [],
	PULL: [IDLE, WALK, STOP, JUMP, FALL, HANG, HOVER, CLIMB, ATTACK, HURT, DIE],
	CLIMB: [IDLE, WALK, STOP, JUMP, FALL, HANG, HOVER, PULL, ATTACK, HURT, DIE],
	ATTACK: [IDLE, WALK, STOP, JUMP, FALL, HANG, HOVER, PULL, CLIMB, HURT, DIE],
	HURT: [IDLE, WALK, STOP, JUMP, FALL, HANG, HOVER, PULL, CLIMB, ATTACK, DIE],
	DIE: [IDLE, WALK, STOP, JUMP, FALL, HANG, HOVER, PULL, CLIMB, ATTACK, HURT],
}

const GRAVITY = 2250*2 # pixels/second/second

const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 1000*2
const WALK_MIN_SPEED = 10*2
const WALK_MAX_SPEED = 250*2
const STOP_FORCE = 5000*2
const JUMP_SPEED = 500*2
const JUMP_FORCE = 32000*2
const JUMP_MAX_AIRBORNE_TIME = 0.01
const TANGENT_ACCELERATION = 1.2
const CLIMB_SPEED  = 200
const RECOVER_FORCE = 50

const SLIDE_STOP_VELOCITY = 0.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 0.0 # one pixel


enum {
	IDLE,		#0 	
	WALK,		#1
	STOP		#2
	JUMP		#3
	FALL		#4
	HANG		#5
	HOVER		#6
	CROUCH		#7
	SNEAK		#8
	PULL		#9
	CLIMB		#10
	ATTACK		#11
	HURT		#12
	DIE			#13
}


var _input_left
var _input_right
var _input_up
var _input_down
var _input_JUMP
var _input_action

var _state
var _velocity
var _force

var _direction_to_twin

var _prev_JUMP_pressed = false
var _on_air_time = 100
var _on_rope_max_distance = false
var _on_rope_min_distance = false
var _was_on_floor = false

var states_strings := {
	IDLE: "idle",
	WALK: "walk",
	STOP: "stop",
	JUMP: "jump",
	FALL: "fall",
	HANG: "hang",
	HOVER: "hover",
	CROUCH: "crouch",
	SNEAK: "sneak",
	PULL: "pull",
	CLIMB: "climb",
	ATTACK: "attack",
	HURT: "hurt",
	DIE: "die",
}

func _init():
	_state = IDLE
	_velocity = Vector2()
	_force = Vector2()
	_direction_to_twin = Vector2()


func set_force_gravity():
	_force = Vector2(0, GRAVITY)


func get_velocity():
	return _velocity


func get_state():
	return _state


func set_state():
	if _was_on_floor:
		if _input_action:
			change_state(ATTACK)
		
		elif _input_up and is_below_twin():
			change_state(CLIMB)
		
		elif _on_rope_max_distance:
			change_state(HOVER)
		
		elif _input_left or _input_right:
			change_state(WALK)
		
		else:
			change_state(IDLE)
	else:
		if _input_action:
			change_state(HANG)
		
		elif _input_up and is_below_twin():
			change_state(CLIMB)
		
		elif _on_rope_max_distance:
			change_state(HOVER)
		
		elif _input_JUMP:
			change_state(JUMP)
		
		else: 
			change_state(FALL)


func change_state(target_state: int) -> void:
	if not target_state in _transitions[_state]:
		return
	_state = target_state
	enter_state()


func enter_state() -> void:
	match _state:
		IDLE:
			_velocity.x = 0.0
		_:
			return


func get_force():
	return _force


func set_direction_to_twin(direction_to_twin):
	_direction_to_twin = direction_to_twin


func set_on_rope_max_distance(on_rope_max_distance):
	_on_rope_max_distance = on_rope_max_distance


func set_on_rope_min_distance(on_rope_min_distance):
	_on_rope_min_distance = on_rope_min_distance


func set_inputs(name):
	_input_left = Input.is_action_pressed(str(name, "_left"))
	_input_right = Input.is_action_pressed(str(name, "_right"))
	_input_up = Input.is_action_pressed(str(name, "_up"))
	_input_down = Input.is_action_pressed(str(name, "_down"))
	_input_JUMP = Input.is_action_pressed(str(name, "_jump"))
	_input_action = Input.is_action_pressed(str(name, "_action"))


func process_kinematics(delta):
	check_on_floor()
	
	linear_velocity_y(delta)
	
	linear_velocity_x(delta)
	
	_velocity += _force * delta
	
	set_state()
	
	match _state:
		JUMP:
			air()
		FALL:
			air()
		HANG:
			hang()
		HOVER:
			swing()
		PULL:
			pull()
		CLIMB:
			climb()
	
	_velocity = move_and_slide(_velocity, Vector2.UP)


func check_on_floor():
	_was_on_floor = false
	if is_on_floor():
		_on_air_time = 0
		_was_on_floor = true


func air():
	#_velocity.x *= 0.8
	pass


func pull():
	pass


func climb():
	var v_tension = _direction_to_twin.normalized() * CLIMB_SPEED
	
	
	_velocity.x = v_tension.x * abs(cos(_direction_to_twin.angle()))
	_velocity.y = v_tension.y * -sin(_direction_to_twin.angle())


func hang():
	_velocity.x = 0
	_velocity.y = 0


# TODO: Fix tangent acceleration
func swing():
	
	# 1: Desc. velocity en tangent i tension
	var angle_between_rope_and_velocity = _direction_to_twin.angle_to(_velocity)
	var angle_between_rope_and_floor = _direction_to_twin.angle()
	
	var v_tangent_lenght = _velocity.length() * sin(angle_between_rope_and_velocity)
	var v_tension_lenght = _velocity.length() * cos(angle_between_rope_and_velocity)
	
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
	if abs(v_tension.angle() - _direction_to_twin.angle()) > 0.1:
		var parent = get_parent()
		var distance_diff = parent.get_distance() - parent.ROPE_MAX_DISTANCE #if (parent.get_distance() > parent.ROPE_MAX_DISTANCE) else 0
		
		v_tension = _direction_to_twin * distance_diff * RECOVER_FORCE #if (distance_diff == 0) else Vector2.ZERO
	
	v_tangent.x -= sin(v_tension.angle()) + 0.5
	v_tangent.y -= sin(v_tension.angle()) + 0.5
	
	# 4: Reconstruim V
	_velocity.x = v_tension.x + v_tangent.x
	_velocity.y = v_tension.y + v_tangent.y
	
	if abs(_velocity.x) < 0.1:
		_velocity.x = 0
	if abs(_velocity.y) < 0.1:
		_velocity.y = 0


func get_angle_in_first_quadrant(angle):
	while angle > PI/2:
		angle -= PI/2
	
	while angle < 0:
		angle += PI/2
	return angle


func linear_velocity_x(delta):
	
	if _input_left:
		if _velocity.x <= WALK_MIN_SPEED and _velocity.x > -WALK_MAX_SPEED:
			_force.x -= WALK_FORCE
			
	elif _input_right:
		if _velocity.x >= -WALK_MIN_SPEED and _velocity.x < WALK_MAX_SPEED:
			_force.x += WALK_FORCE
	
	elif _state != HOVER or is_on_floor(): 
		var vsign = sign(_velocity.x)
		var vlen = abs(_velocity.x)

		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0

		_velocity.x = vlen * vsign


func linear_velocity_y(delta):
	set_force_gravity()
		
	if _state == FALL:
		pass
	
	if _on_air_time < JUMP_MAX_AIRBORNE_TIME and _input_JUMP and not _prev_JUMP_pressed and not _state == JUMP:
		# _input_JUMP must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		_velocity.y = -JUMP_SPEED
	
	_on_air_time += delta
	_prev_JUMP_pressed = _input_JUMP


func is_above_twin():
	return sin(_direction_to_twin.angle()) > 0.1 and not _on_rope_min_distance


func is_below_twin():
	return sin(_direction_to_twin.angle()) < -0.1 and not _on_rope_min_distance