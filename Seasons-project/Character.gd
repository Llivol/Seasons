extends KinematicBody2D
class_name Character

signal health_changed(new_value)
signal flip()

var MAX_HEALTH

var _velocity
var _direction
var _current_health setget set_health, get_health

func _ready():
	_direction = 1

func set_health(new_value):
	_current_health = max(0, new_value)
	emit_signal("health_changed", _current_health)

func get_health():
	return _current_health

func flip_direction():
	_direction = 1 if (_direction == -1) else -1
	_velocity = Vector2.ZERO
	self.scale.x *= -1
	emit_signal("flip", _direction)