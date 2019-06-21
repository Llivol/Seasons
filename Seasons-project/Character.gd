extends KinematicBody2D
class_name Character

signal health_changed(new_value)
signal flip()

const KNOCKBACK_MULTIPLIER = 300

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

func increase_max_health(value):
	MAX_HEALTH += value
	set_health(MAX_HEALTH)
	$HealthBar.update_max_health()

func get_health():
	return _current_health


func get_sprite():
	return $Sprite


func get_sprite_size():
	var sprite_size = Vector2()
	sprite_size.x = $Sprite.texture.get_size().x
	sprite_size.y = $Sprite.texture.get_size().y
	return sprite_size


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
	var damage = self.DAMAGE
	var size_diff = self.SIZE / body.SIZE
	body.apply_velocity((body.global_position - global_position).normalized() * KNOCKBACK_MULTIPLIER * size_diff)
	body.take_damage(DAMAGE)


func die():
	pass