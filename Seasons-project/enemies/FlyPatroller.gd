extends KinematicBody2D

onready var ledge_detector = $LedgeDetector
onready var fly_timer = $FlyTimer

const MAX_SPEED = Global.SPEED_FAST
const SIZE = Global.SIZE_SMALL
const FLY_TIME = 2
const ACCELERATION = 20
const GRAVITY = 0

var _direction
var _motion


func _ready():
	_direction = 1
	_motion = Vector2()
	ledge_detector.translate(Vector2(SIZE, 0))
	fly_timer.set_wait_time(FLY_TIME)

func _process(delta):
	if ledge_detector.is_near_wall():
		flip_direction()


func _physics_process(delta):
	_motion.x = min(_motion.x + ACCELERATION, MAX_SPEED) if (_direction == 1) else max(_motion.x - ACCELERATION, -MAX_SPEED)
	_motion.y = GRAVITY * delta
	_motion = move_and_slide(_motion)


func flip_direction():
	_direction = 1 if (_direction == -1) else -1
	_motion.x = 0
	self.scale.x *= -1
	fly_timer.start(FLY_TIME)

func _on_FlyTimer_timeout():
	flip_direction()
