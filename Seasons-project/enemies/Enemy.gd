extends KinematicBody2D
class_name Enemy

const GRAVITY = 7000
const ACCELERATION = 20

#FINAL
var MAX_SPEED
var SIZE
var AWARENESS
var DAMAGE

var _motion
var _direction

func _ready():
	_direction = 1
	_motion = Vector2()

func set_stats(size, max_speed, damage, awareness = 0):
	SIZE = size
	MAX_SPEED = max_speed
	DAMAGE = damage
	AWARENESS = awareness

func move(delta, flying = false):
	_motion.x = min(_motion.x + ACCELERATION, MAX_SPEED) if (_direction == 1) else max(_motion.x - ACCELERATION, -MAX_SPEED)
	_motion.y = GRAVITY * delta if (not flying) else 0
	_motion = move_and_slide(_motion)


func flip_direction():
	_direction = 1 if (_direction == -1) else -1
	_motion = Vector2.ZERO
	self.scale.x *= -1


func attack(player):
	flip_direction()