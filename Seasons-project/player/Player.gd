extends Character
class_name Player

signal stamina_changed(new_value)

export var default_color = Global.COLOR_BLUE
export var default_color_dark = Global.COLOR_DARK_BLUE

onready var attack_range = $AttackRange

onready var _transitions := {
	AIR: [ATTACK, DEAD, HANG, HOVER, HURT, IDLE, WALK],
	ATTACK: [AIR, CROUCH, EXHAUST, HOVER, IDLE, JUMP, SNEAK, WALK],
	CLIMB: [AIR, DEAD, EXHAUST, HANG, HOVER, HURT, IDLE],
	CROUCH: [],
	DEAD: [REVIVE],
	EXHAUST: [DEAD, HOVER, HURT, RECOVER],
	HANG: [AIR, CLIMB, DEAD, EXHAUST, HOVER],
	HOVER: [AIR, ATTACK, CLIMB, CROUCH, DEAD, HANG, HURT, IDLE, JUMP, PULL, RECOVER, WALK],
	HURT: [AIR, CLIMB, CROUCH, DEAD, EXHAUST, HANG, HOVER, HURT, IDLE, JUMP, PULL, SNEAK, WALK],
	IDLE: [AIR, ATTACK, CLIMB, CROUCH, DEAD, HANG, HOVER, HURT, JUMP, PULL, RECOVER, SNEAK, WALK],
	JUMP: [AIR, ATTACK, CLIMB, DEAD, EXHAUST, HANG, HOVER, HURT, IDLE],
	PULL: [AIR, CROUCH, EXHAUST, DEAD, HOVER, HURT, IDLE],
	RECOVER: [AIR, ATTACK, CLIMB, CROUCH, DEAD, HOVER, HURT, JUMP, PULL, STOP, WALK],
	REVIVE: [IDLE],
	SNEAK: [],
	STOP: [AIR, IDLE, WALK, JUMP, HANG, HOVER, PULL, CLIMB, ATTACK, HURT, DEAD, EXHAUST],
	WALK: [AIR, ATTACK, CLIMB, DEAD, HOVER, HURT, IDLE, JUMP, PULL, STOP],
}
const GRAVITY = 3000

const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 1000
const WALK_MIN_SPEED = 10
const WALK_MAX_SPEED = 250
const STOP_FORCE = 5000
const STOP_HOVER_FORCE = 100
const JUMP_SPEED = 570
const JUMP_FORCE = 32000
const JUMP_MAX_AIRBORNE_TIME = 0.01
const TANGENT_ACCELERATION = 1.2
const CLIMB_SPEED  = 100
const RECOVER_FORCE = 25
const AIR_FRICCTION = 0.001
const STAMINA_UNIT = 10
const IDLE_TIME_TO_RECOVER_STAMINA = 1
const EXHAUSTED_TIME_TO_RECOVER_STAMINA = 3
const RECOVER_SPEED_FROM_IDLE = 10.0
const RECOVER_SPEED_FROM_EXHAUSTED = 2.5
const CUT_THE_ROPE_TIME = 2
const BONUS_HEALTH = 1
const BONUS_STAMINA = STAMINA_UNIT

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
var _input_action
var _input_pickaxe

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
var _parent

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
	_parent = get_parent()
	$AttackCooldown.connect("timeout", self, "_on_AttackCooldown_timeout")
	$InvulnerabilityWindow.connect("timeout", self, "_on_InvulnerabilityWindow_timeout")
	$RecoverStamina.connect("timeout", self, "_on_RecoverStamina_timeout")
	$CutTheRope.connect("timeout", self, "_on_CutTheRope_timeout")


func _process(delta):
	if _started:
		return

	if SIZE != null:
		$Collision.shape.set_extents(Vector2($Sprite.texture.get_size().x / 2, $Sprite.texture.get_size().y / 2))
		_started = true
		update()


func _draw():
	pass


func _input(event):
	if event.is_action_pressed(str(name, "_pickaxe")):
		change_state(ATTACK)
	if _parent.is_joint() and _parent.get_twin(self).is_dead():
		if event.is_action_pressed(str(name, "_pickaxe")):
			$CutTheRope.start(CUT_THE_ROPE_TIME)
	
		if event.is_action_released(str(name, "_pickaxe")):
			$CutTheRope.stop()


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


func set_state():
	if _current_health <= 0:
		change_state(DEAD)
		return

	if _input_pickaxe:
		if not is_on_floor() and not (_input_right or _input_left):
			change_state(HANG)
			
	elif (_input_action and _input_up) and is_below_twin():
		change_state(CLIMB)
		
	elif (_input_action and _input_down) and is_above_twin():
		change_state(PULL)
		
	elif _on_rope_max_distance:
		change_state(HOVER)
	
	elif _current_stamina <= 0:
		change_state(EXHAUST)
		
	elif is_on_floor(): 
		if _input_action:
			change_state(JUMP)
		elif _velocity.x:
			change_state(WALK)
		else:
			change_state(IDLE)
	else:
			change_state(AIR)


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
			consume_stamina(STAMINA_UNIT)

		PULL:
			return

		RECOVER:
			_recover_speed = RECOVER_SPEED_FROM_EXHAUSTED if (_prev_state == EXHAUST) else RECOVER_SPEED_FROM_IDLE

		REVIVE:
			if _parent.is_joint() and _current_health == 0:
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


func is_dead():
	return _state == DEAD


func set_inputs(name):
	_input_left = Input.is_action_pressed(str(name, "_left"))
	_input_right = Input.is_action_pressed(str(name, "_right"))
	_input_up = Input.is_action_pressed(str(name, "_up"))
	_input_down = Input.is_action_pressed(str(name, "_down"))
	_input_action = Input.is_action_pressed(str(name, "_action"))
	_input_pickaxe = Input.is_action_pressed(str(name, "_pickaxe"))


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
		"action":
			return _input_action
		"pickaxe":
			return _input_pickaxe


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


func take_damage(value):
	if is_invulnerable or Cheats.infinite_health: 
		return
	.take_damage(value)
	change_state(HURT)
	if _current_health == 0:
		change_state(DEAD)


func recover_health(value):
	if _current_health < MAX_HEALTH:
		set_health(_current_health + value)
	else: 
		increase_max_health(BONUS_HEALTH)


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
	if _current_stamina < MAX_STAMINA:
		set_stamina(_current_stamina + value)
	else:
		increase_max_stamina()


func increase_max_stamina():
	MAX_STAMINA += BONUS_STAMINA
	set_stamina(MAX_STAMINA)
	$StaminaBar.update_max_stamina()


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
			consume_stamina(STAMINA_UNIT * delta)

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
			recover_stamina(_recover_speed * STAMINA_UNIT * delta) if(_current_stamina < MAX_STAMINA) else set_stamina(MAX_STAMINA)

		PULL:
			process_pull(delta)
			consume_stamina(STAMINA_UNIT * delta)
	
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
		_velocity.x *= 0.95
	_on_air_time += delta


func process_jump():
	if _on_air_time < JUMP_MAX_AIRBORNE_TIME:
		_velocity.y = -JUMP_SPEED


func process_pull(delta):
	var v_tension = _direction_to_twin.normalized() * CLIMB_SPEED
	var broda = get_parent().get_twin(self)
	var velocity = Vector2()
	velocity.x = - v_tension.x * abs(cos(_direction_to_twin.angle()))
	velocity.y = v_tension.y * -sin(_direction_to_twin.angle())
	velocity.y += GRAVITY * delta
	broda.apply_velocity(velocity)


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
	if _input_left or _input_right or _input_action or _input_pickaxe:
		$RecoverStamina.stop()
		$RecoverStamina.set_wait_time(EXHAUSTED_TIME_TO_RECOVER_STAMINA)
		$RecoverStamina.start()


func process_dead():
	_velocity.x = 0
	if _on_hug_distance or _current_health > 0:
		change_state(REVIVE)


""" AUXILIAR """

func flip_direction():
	if _state == DEAD:
		return
	.flip_direction()


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


func _on_CutTheRope_timeout():
	_parent.cut_the_rope(self)
	$CutTheRope.queue_free()


func _on_viewport_exited(viewport):
	set_health(0)
	set_stamina(0)
	change_state(DEAD)