extends KinematicBody2D

const SPEED = 200
const GRAVITY = 7000

var _direction

func _ready():
	_direction = 1


func _physics_process(delta):
	var velocity := Vector2(SPEED * _direction, GRAVITY * delta)
	move_and_slide((velocity))
	_check_collision(get_slide_collision(0))

func _on_LeftArea_body_exited(body):
	_flip_direction()


func _on_RightArea_body_exited(body):
	_flip_direction()


func _flip_direction():
	_direction = 1 if (_direction == -1) else -1


func _check_collision(collision):
	if not collision or collision.get_normal().x == 0: 
		return
	
	if collision.get_normal().x != 0:
		_flip_direction()