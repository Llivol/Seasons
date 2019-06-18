extends KinematicBody2D
class_name Character

signal health_changed(new_value)
signal flip()

const KNOCKBACK_MULTIPLIER = 500

var MAX_HEALTH
var DAMAGE

var _velocity
var _direction
var _current_health setget set_health, get_health

func _ready():
	_direction = 1

func take_damage(value):
	set_health(_current_health - value)

func set_health(value):
	var new_value = min (value, MAX_HEALTH)
	_current_health = max(0, new_value)
	emit_signal("health_changed", _current_health)
	if _current_health == 0:
		die()

func get_health():
	return _current_health


func get_sprite():
	return $Sprite


func flip_direction():
	_direction = 1 if (_direction == -1) else -1
	_velocity = Vector2.ZERO
	self.scale.x *= -1
	emit_signal("flip", _direction)


func apply_velocity(velocity):
	_velocity += velocity
	_velocity = move_and_slide(velocity)


func attack(body):
	var knockback = KNOCKBACK_MULTIPLIER
	var damage = DAMAGE
	body.apply_velocity((body.global_position - global_position).normalized() * KNOCKBACK_MULTIPLIER * DAMAGE)
	body.take_damage(DAMAGE)


func die():
	pass