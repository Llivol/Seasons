extends StaticBody2D
class_name Hazard

signal health_changed(new_value)

const KNOCKBACK_MULTIPLIER = 300

var SIZE
var MAX_HEALTH
var DAMAGE
var BELOW

onready var ledge_detector = $LedgeDetector

var gravity

var _current_health setget set_health, get_health

func _process(delta):
	if not ledge_detector.is_near_floor() and not ledge_detector.is_near_ceil():
		position = position + gravity * delta

func set_stats(size, health, damage, below):
	SIZE = size
	MAX_HEALTH = health
	_current_health = health
	DAMAGE = damage
	BELOW = below
	gravity = Vector2(0, -10) if BELOW else Vector2(0, 10)
	set_sprite_size()

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


func set_sprite_size():
	var scale = Vector2(get_size_multiplier(), get_size_multiplier())
	$Sprite.set_scale(scale)


func get_size_multiplier():
	return SIZE / Global.SIZE_AVERAGE


func attack(body, knockback = true):
	var size_diff = self.SIZE / body.SIZE
	print("attack")
	print(knockback)
	if knockback:
		body.apply_velocity((body.global_position - global_position).normalized() * KNOCKBACK_MULTIPLIER * size_diff)
	body.take_damage(DAMAGE)

func apply_velocity(velocity):
	return

func die():
	queue_free()