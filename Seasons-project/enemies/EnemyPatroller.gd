extends KinematicBody2D

onready var ledge_detector = $LedgeDetector

const MAX_SPEED = Global.SPEED_AVERAGE
const ACCELERATION = 20
const GRAVITY = 7000
const SIZE = Global.SIZE_SMALL

var _direction
var _motion

var prev_collision_detected = false

func _ready():
	_direction = 1
	_motion = Vector2()
	ledge_detector.translate(Vector2(SIZE, 0))

func _process(delta):
	if ledge_detector.is_near_ledge() or ledge_detector.is_near_wall():
		flip_direction()


func _physics_process(delta):
	_motion.x = min(_motion.x + ACCELERATION, MAX_SPEED) if (_direction == 1) else max(_motion.x - ACCELERATION, -MAX_SPEED)
	_motion.y = GRAVITY * delta
	move_and_slide(_motion)


func flip_direction():
	_direction = 1 if (_direction == -1) else -1
	_motion.x = 0
	self.scale.x *= -1