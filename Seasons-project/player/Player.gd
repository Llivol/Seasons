extends Character
class_name Player

signal stamina_changed(new_value)

export var default_color = Global.COLOR_BLUE
export var default_color_dark = Global.COLOR_DARK_BLUE

onready var attack_range = $AttackRange
"""
onready var _transitions := {
	IDLE: [WALK, STOP, JUMP, AIR, HANG, HOVER, PULL, CLIMB, ATTACK, HURT, DEAD, EXHAUST, RECOVER],
	WALK: [IDLE, STOP, JUMP, AIR, HOVER, ATTACK, HURT, DEAD, EXHAUST],
	STOP: [IDLE, WALK, JUMP, AIR, HANG, HOVER, PULL, CLIMB, ATTACK, HURT, DEAD, EXHAUST],
	JUMP: [IDLE, AIR, HANG, HOVER, ATTACK, HURT, DEAD, EXHAUST],
	AIR: [IDLE, WALK, HANG, HOVER, ATTACK, HURT, DEAD, EXHAUST],
	HANG: [AIR, CLIMB, HOVER, HURT, DEAD, EXHAUST],
	HOVER: [IDLE, WALK, STOP, JUMP, AIR, HANG, PULL, CLIMB, ATTACK, HURT, DEAD, EXHAUST],
	CROUCH: [],
	SNEAK: [],
	PULL: [IDLE, HOVER, HURT, DEAD, EXHAUST],
	CLIMB: [IDLE, AIR, HANG, HOVER, HURT, DEAD, EXHAUST],
	ATTACK: [IDLE, WALK, STOP, JUMP, AIR, HOVER, HURT, DEAD, EXHAUST],
	HURT: [IDLE, WALK, STOP, JUMP, AIR, HANG, HOVER, PULL, CLIMB, ATTACK, DEAD, EXHAUST],
	DEAD: [REVIVE],
	EXHAUST: [HOVER, HURT, DEAD, RECOVER], #[IDLE, WALK, STOP, AIR, HOVER],
	RECOVER: [WALK, JUMP, HANG, PULL, CLIMB, ATTACK, HURT, DEAD],
	REVIVE: [WALK, JUMP, HANG, PULL, CLIMB, ATTACK, HURT, DEAD]
}
"""

onready var _transitions := {
	AIR: [ATTACK, HANG, HOVER, HURT, IDLE, WALK],
	ATTACK: [AIR, CROUCH, EXHAUST, HOVER, IDLE, JUMP, SNEAK, WALK],
	CLIMB: [AIR, EXHAUST, HANG, HOVER, HURT, IDLE],
	CROUCH: [],
	DEAD: [REVIVE],
	EXHAUST: [HOVER, HURT, RECOVER],
	HANG: [AIR, CLIMB, EXHAUST, HOVER],
	HOVER: [AIR, ATTACK, CLIMB, CROUCH, HANG, HURT, IDLE, JUMP, PULL, RECOVER, WALK],
	HURT: [AIR, CLIMB, CROUCH, DEAD, EXHAUST, HANG, HOVER, HURT, IDLE, JUMP, PULL, SNEAK, WALK],
	IDLE: [AIR, ATTACK, CLIMB, CROUCH, HANG, HOVER, HURT, JUMP, PULL, RECOVER, SNEAK, WALK],
	JUMP: [AIR, ATTACK, CLIMB, EXHAUST, HANG, HOVER, HURT, IDLE],
	PULL: [AIR, CROUCH, EXHAUST, HOVER, HURT, IDLE],
	RECOVER: [AIR, ATTACK, CLIMB, CROUCH, HOVER, HURT, JUMP, PULL, STOP, WALK],
	REVIVE: [IDLE],
	SNEAK: [],
	STOP: [AIR, IDLE, WALK, JUMP, HANG, HOVER, PULL, CLIMB, ATTACK, HURT, DEAD, EXHAUST],
	WALK: [AIR, ATTACK, CLIMB, HOVER, HURT, IDLE, JUMP, PULL, STOP],
}
const GRAVITY = 4500

const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 2000
const WALK_MIN_SPEED = 20
const WALK_MAX_SPEED = 500
const STOP_FORCE = 10000
const STOP_HOVER_FORCE = 200
const JUMP_SPEED = 1000
const JUMP_FORCE = 64000
const JUMP_MAX_AIRBORNE_TIME = 0.01
const TANGENT_ACCELERATION = 1.2
const CLIMB_SPEED  = 200
const RECOVER_FORCE = 50
const AIR_FRICCTION = 0.001
const STAMINA_UNIT = 10
const IDLE_TIME_TO_RECOVER_STAMINA = 1
const EXHAUSTED_TIME_TO_RECOVER_STAMINA = 3
const RECOVER_SPEED_FROM_IDLE = 10
const RECOVER_SPEED_FROM_EXHAUSTED = 2.5

const SLIDE_STOP_VELOCITY = 0.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 0.0 # one pixel


enum {
	AIR,
	ATTACK, 
	CLIMB,
	CROUCH, 
	DEAD,
	EXHAUST,
	HANG, 
	HOVER, 
	HURT, 
	IDLE, 
	JUMP, 
	PULL, 
	RECOVER, 
	REVIVE, 
	SNEAK, 
	STOP, 
	WALK, 
}

var SIZE
var MAX_STAMINA
var ATTACK_CD
var INVULNERABILITY_TIME

var _input_left
var _input_right
var _input_up
var _input_down
var _input_jump
var _input_action

var _state
var _prev_state
var _force setget set_force, get_force
var _current_stamina setget set_stamina, get_stamina

var _direction_to_twin

var _on_air_time = 100
var _on_rope_max_distance = false
var _on_rope_min_distance = false
var _on_hug_distance = false
var _recover_speed

var _started = false

var can_attack = true
var is_invulnerable = false
var is_recovering = false

var states_strings := {
	AIR: "air",
	ATTACK: "attack", 
	CLIMB: "climb",
	CROUCH: "crouch", 
	DEAD: "dead",
	EXHAUST: "exhaust",
	HANG: "hang", 
	HOVER: "hover", 
	HURT: "hurt", 
	IDLE: "idle", 
	JUMP: "jump", 
	PULL: "pull", 
	RECOVER: "recover", 
	REVIVE: "revive", 
	SNEAK: "sneak", 
	STOP: "stop", 
	WALK: "walk", 
}


""" PRIVATE """

func _init():
	_state = IDLE
	_prev_state = IDLE
	_velocity = Vector2()
	_force = Vector2()
	_direction_to_twin = Vector2()


func _ready():
	$AttackCooldown.connect("timeout", self, "_on_AttackCooldown_timeout")
	$InvulnerabilityWindow.connect("timeout", self, "_on_InvulnerabilityWindow_timeout")
	$RecoverStamina.connect("timeout", self, "_on_RecoverStamina_timeout")


func _process(delta):
	if _started:
		return

	if SIZE != null:
		$Collision.shape.set_extents(Vector2($Sprite.texture.get_size().x / 2, $Sprite.texture.get_size().y / 2))
		_started = true
		update()


func _draw():
	pass
	"""
	var shape: = $Collision
	var extents: Vector2 = shape.shape.extents * 2.0
	draw_rect(Rect2(shape.position - extents / 2.0, extents), default_color_dark)
	extents *= 0.8
	draw_rect(Rect2(shape.position - extents / 2.0, extents), default_color)
	draw_circle(shape.position + Vector2(SIZE/2, -SIZE/2), SIZE/8, default_color_dark)
	"""


""" GETTERS & SETTERS """

func set_stats(size, max_health = 6, max_stamina = 100, damage = 2, attack_cd = 0.5, invulnerability_time = 1):
	SIZE = size
	MAX_HEALTH = max_health
	_current_health = max_health
	MAX_STAMINA = max_stamina
	_current_stamina = max_stamina
	DAMAGE = damage
	ATTACK_CD = attack_cd
	INVULNERABILITY_TIME = invulnerability_time


func set_colors(default_color, default_color_dark):
	self.default_color = default_color
	self.default_color_dark = default_color_dark


func change_state(target_state: int) -> void:
	if not target_state in _transitions[_state]:
		return
	_prev_state = _state
	_state = target_state
	leave_state()
	enter_state()


func enter_state() -> void:
	match _state:

		AIR:
			return

		ATTACK:
			attack(attack_range.get_enemy_in_range())
			consume_stamina(STAMINA_UNIT / 2)
			change_state(_prev_state)

		CLIMB: 
			return

		DEAD:
			if Cheats.unkillable:
				set_health(MAX_HEALTH)
				change_state(_prev_state)

		EXHAUST:
			$RecoverStamina.set_wait_time(EXHAUSTED_TIME_TO_RECOVER_STAMINA)
			$RecoverStamina.start()

		HANG: 
			return

		HOVER:
			return

		HURT:
			$InvulnerabilityWindow.start()
			is_invulnerable = true
			change_state(_prev_state)

		IDLE:
			$RecoverStamina.set_wait_time(IDLE_TIME_TO_RECOVER_STAMINA)
			$RecoverStamina.start()

		JUMP: 
			process_jump()
			consume_stamina(STAMINA_UNIT * 2)

		PULL:
			return

		RECOVER:
			_recover_speed = RECOVER_SPEED_FROM_EXHAUSTED if (_prev_state == EXHAUST) else RECOVER_SPEED_FROM_IDLE

		REVIVE:
			recover_health(1)

		WALK:
			return

		_:
			return


func leave_state() -> void:
	match _state:

		AIR:
			return

		ATTACK:
			attack(attack_range.get_enemy_in_range())
			consume_stamina(STAMINA_UNIT / 2)
			change_state(_prev_state)

		CLIMB: 
			return

		DEAD:
			if Cheats.unkillable:
				set_health(MAX_HEALTH)
				change_state(_prev_state)

		EXHAUST:
			$RecoverStamina.set_wait_time(EXHAUSTED_TIME_TO_RECOVER_STAMINA)
			$RecoverStamina.start()

		HANG: 
			return

		HOVER:
			return

		HURT:
			$InvulnerabilityWindow.start()
			is_invulnerable = true
			change_state(_prev_state)

		IDLE:
			$RecoverStamina.stop()
			is_recovering = false

		JUMP: 
			return

		PULL:
			return

		RECOVER:
			_recover_speed = RECOVER_SPEED_FROM_EXHAUSTED if (_prev_state == EXHAUST) else RECOVER_SPEED_FROM_IDLE

		REVIVE:
			recover_health(1)

		WALK:
			return

		_:
			return


func get_state():
	return _state


func set_inputs(name):
	_input_left = Input.is_action_pressed(str(name, "_left"))
	_input_right = Input.is_action_pressed(str(name, "_right"))
	_input_up = Input.is_action_pressed(str(name, "_up"))
	_input_down = Input.is_action_pressed(str(name, "_down"))
	_input_jump = Input.is_action_pressed(str(name, "_jump"))
	_input_action = Input.is_action_pressed(str(name, "_action"))


func get_input(name):
	match name:
		"left":
			return _input_left
		"right":
			return _input_right
		"up":
			return _input_up
		"down":
			return _input_down
		"jump":
			return _input_jump
		"action":
			return _input_action


func get_force():
	return _force


func set_force(force):
	_force = force


func add_force(force):
	_force += force


func set_force_gravity():
	_force = Vector2(0, GRAVITY)


func get_velocity():
	return _velocity


func set_state():
	if _input_action:
		if not is_on_floor() and not (_input_right or _input_left):
			change_state(HANG)
		else:
			change_state(ATTACK)
			
	elif (_input_jump and _input_up) and is_below_twin():
		change_state(CLIMB)
			
	elif _on_rope_max_distance:
		change_state(HOVER)
	
	elif _current_stamina <= 0:
		change_state(EXHAUST)
		
	elif is_on_floor(): 
		if _input_jump:
			change_state(JUMP)
		elif _velocity.x:
			change_state(WALK)
		else:
			change_state(IDLE)
	else:
			change_state(AIR)


func take_damage(value):
	if is_invulnerable or Cheats.infinite_health: 
		return
	.take_damage(value)
	change_state(HURT)
	if _current_health == 0:
		change_state(DEAD)


func recover_health(value):
	set_health(_current_health + value)


func get_stamina():
	return _current_stamina


func set_stamina(value):
	var new_value = min (value, MAX_STAMINA)
	_current_stamina = max(0, new_value)
	emit_signal("stamina_changed", _current_stamina)
	if _current_stamina == 0:
		change_state(EXHAUST)


func consume_stamina(value):
	if Cheats.infinite_stamina:
		return
	set_stamina(_current_stamina - value)


func recover_stamina(value):
	set_stamina(_current_stamina + value)


func set_direction_to_twin(direction_to_twin):
	_direction_to_twin = direction_to_twin


func set_on_rope_max_distance(on_rope_max_distance):
	_on_rope_max_distance = on_rope_max_distance


func set_on_rope_min_distance(on_rope_min_distance):
	_on_rope_min_distance = on_rope_min_distance


func set_on_hug_distance(on_hug_distance):
	_on_hug_distance = on_hug_distance


""" KINEMATICS """

func process_kinematics(delta):
	check_on_floor()
	
	linear_velocity_y(delta)
	
	linear_velocity_x(delta)
	
	_velocity += _force * delta
	
	set_state()
	
	match _state:

		AIR:
			process_air(delta)

		ATTACK:
			return

		CLIMB:
			process_climb(delta)
			consume_stamina(STAMINA_UNIT / 2 * delta)

		DEAD:
			process_dead()

		EXHAUST:
			_velocity.x *= 0.5
			process_exhaust()

		HANG:
			process_hang()
			consume_stamina(STAMINA_UNIT * delta)

		HOVER:
			process_hover()

		HURT:
			return

		RECOVER:
			recover_stamina(_recover_speed * STAMINA_UNIT * delta)

		PULL:
			process_pull()
	
	_velocity = move_and_slide(_velocity, Vector2.UP)


func linear_velocity_x(delta):
	
	if _input_left:
		if _velocity.x > 1 and not _state == HOVER:
			_velocity.x = 0
		if _velocity.x <= WALK_MIN_SPEED and _velocity.x > -WALK_MAX_SPEED:
			_force.x -= WALK_FORCE
			if _direction == 1:
				flip_direction()
			
	elif _input_right :
		if _velocity.x < 0 and not _state == HOVER:
			_velocity.x = 0
		if _velocity.x >= -WALK_MIN_SPEED and _velocity.x < WALK_MAX_SPEED:
			_force.x += WALK_FORCE
			if _direction == -1:
				flip_direction()
	
	elif _state == HOVER or is_on_floor(): 
		var vsign = sign(_velocity.x)
		var vlen = abs(_velocity.x)

		vlen -= STOP_FORCE * delta if (not _state == HOVER or is_on_floor()) else STOP_HOVER_FORCE * delta 
		if vlen < 0:
			vlen = 0

		_velocity.x = vlen * vsign


func linear_velocity_y(delta):
	set_force_gravity()


func process_air(delta):
	if _state == AIR:
		_velocity.x *= 0.9
	_on_air_time += delta


func process_jump():
	if _on_air_time < JUMP_MAX_AIRBORNE_TIME:
		_velocity.y = -JUMP_SPEED


func process_pull():
	pass


func process_climb(delta):
	var v_tension = _direction_to_twin.normalized() * CLIMB_SPEED
	
	_velocity.x = v_tension.x * abs(cos(_direction_to_twin.angle()))
	_velocity.y = v_tension.y * -sin(_direction_to_twin.angle())
	_velocity.y += GRAVITY * delta


func process_hang():
	_velocity.x = 0
	_velocity.y = 0


func process_hover():
	
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
	
	if not (_input_left or _input_right):
		v_tangent.x *= (1 - AIR_FRICCTION)
		v_tangent.y  *= (1 - AIR_FRICCTION)
		pass
	
	# 4: Reconstruim V
	_velocity.x = v_tension.x + v_tangent.x
	_velocity.y = v_tension.y + v_tangent.y


func attack(enemy):
	if (enemy and can_attack):
		.attack(enemy)
		$AttackCooldown.start()
		can_attack = false


func process_exhaust():
	if _input_left or _input_right or _input_jump or _input_action:
		$RecoverStamina.stop()
		$RecoverStamina.set_wait_time(EXHAUSTED_TIME_TO_RECOVER_STAMINA)
		$RecoverStamina.start()


func process_dead():
	_velocity.x = 0
	if _on_hug_distance:
		change_state(REVIVE)


""" AUXILIAR """

func get_angle_in_first_quadrant(angle):
	while angle > PI/2:
		angle -= PI/2
	
	while angle < 0:
		angle += PI/2
	return angle


func check_on_floor():
	if is_on_floor():
		_on_air_time = 0


func is_above_twin():
	return sin(_direction_to_twin.angle()) > 0.1 and not _on_rope_min_distance


func is_below_twin():
	var parent = get_parent()
	return sin(_direction_to_twin.angle()) < -0.1 and not _on_rope_min_distance


""" SIGNALS """

func _on_AttackCooldown_timeout():
	can_attack = true
	$AttackCooldown.stop()


func _on_InvulnerabilityWindow_timeout():
	is_invulnerable = false
	$InvulnerabilityWindow.stop()


func _on_RecoverStamina_timeout():
	change_state(RECOVER)
	$RecoverStamina.stop()