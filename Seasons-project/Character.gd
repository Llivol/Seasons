extends KinematicBody2D
class_name Character

signal health_changed(new_value)

var MAX_HEALTH

var _current_health setget set_health, get_health

func set_health(new_value):
	_current_health = max(0, new_value)
	emit_signal("health_changed", _current_health)

func get_health():
	return _current_health