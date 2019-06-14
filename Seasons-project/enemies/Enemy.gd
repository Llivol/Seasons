extends Character
class_name Enemy

const GRAVITY = 7000
const ACCELERATION = 20
const CHASE_MULTIPLIER = 1.5

#FINAL
var MAX_SPEED
var SIZE
var AWARENESS

var _target

func _ready():
	_direction = 1
	_velocity = Vector2()

func set_stats(max_health, size, max_speed, damage, awareness = 0):
	MAX_HEALTH = max_health
	_current_health = max_health / 2
	SIZE = size
	MAX_SPEED = max_speed
	DAMAGE = damage
	AWARENESS = awareness

func move(delta, flying = false):
	_velocity.x = min(_velocity.x + ACCELERATION, MAX_SPEED) if (_direction == 1) else max(_velocity.x - ACCELERATION, -MAX_SPEED)
	_velocity.y = GRAVITY * delta if (not flying) else 0
	_velocity = move_and_slide(_velocity)


func chase(delta, flying = false, at_max_floor_distance = false): 
	var direction_to_target = (_target.global_position - global_position).normalized() 
	_velocity.x = min(_velocity.x + ACCELERATION, MAX_SPEED * CHASE_MULTIPLIER) if (direction_to_target.x > 0) else max(_velocity.x - ACCELERATION, -MAX_SPEED * CHASE_MULTIPLIER)
	if not flying:
		_velocity.y = GRAVITY * delta
	else:
		_velocity.y = min(_velocity.y + ACCELERATION, MAX_SPEED * CHASE_MULTIPLIER) if (direction_to_target.y > 0) else max(_velocity.y - ACCELERATION, -MAX_SPEED * CHASE_MULTIPLIER) 
		if at_max_floor_distance and _velocity.y > 0:
			_velocity.y = 0
	_velocity = move_and_slide(_velocity)


func flip_direction():
	if _target == null:
		.flip_direction()
	else:
		var direction_to_target = (_target.global_position - position).normalized()
		if _direction != 1 * sign(direction_to_target.x):
			_direction = 1 * sign(direction_to_target.x)
			self.scale.x *= -1
			emit_signal("flip", _direction)
		


func update_direction():
	if _direction != sign(_velocity.x):
		_direction = sign(_velocity.x)
		self.scale.x *= -1
	

func attack(player):
	if not player.is_invulnerable:
		.attack(player)
	flip_direction()


func die():
	.die()
	drop()
	queue_free()


func drop():
	randomize()
	if randf() < Global.DROP_CHANCE:
		randomize()
		var power_up_scene = load("res://powerups/HealthUp.tscn") if (randf() < 0.5) else load("res://powerups/StaminaUp.tscn")
		var power_up = power_up_scene.instance()
		power_up.set_position(position)
		get_parent().add_child(power_up)