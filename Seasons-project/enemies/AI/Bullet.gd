extends Area2D

const KNOCKBACK_MULTIPLIER = 100

var SIZE
var SPEED
var DAMAGE

var _parent

var _direction setget set_direction

var default_color = Global.COLOR_RED

func _ready():
	connect("body_entered", self, "_on_body_entered")
	position = Vector2.ZERO


func set_stats(parent, size, speed, damage):
	_parent = parent
	self.SIZE = size
	self.SPEED = speed
	self.DAMAGE = damage
	update()

func _process(delta):

	position += _direction * SPEED * delta

	"""
	if _parent != null and _parent.BULLET_SPEED != null:
		
		SPEED = _parent.BULLET_SPEED
		SIZE = _parent.BULLET_SIZE
		DAMAGE = _parent.BULLET_DAMAGE
		default_color = _parent.default_color
		_init = true
		update()
	"""

func _draw():
	if SIZE:
		draw_circle(Vector2.ZERO, SIZE, default_color)


func set_direction(direction):
	_direction = direction
	randomize()
	_direction += Vector2(randf() / 10, randf() / 10)


func _on_body_entered(body):
	if body == _parent:
		return
	if body is Character:
		body.apply_velocity((body.global_position - global_position).normalized() * KNOCKBACK_MULTIPLIER * DAMAGE)
		body.take_damage(DAMAGE)
	queue_free()