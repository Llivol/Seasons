extends Area2D

const KNOCKBACK_MULTIPLIER = 100

var SIZE
var SPEED
var DAMAGE

var _parent
var _init

var _direction setget set_direction

var default_color

func _ready():
	connect("body_entered", self, "_on_body_entered")
	_parent = get_parent()
	position = Vector2.ZERO
	_init = false


func _process(delta):
	if _init:
		position += _direction * SPEED * delta
		return
	
	if _parent != null and _parent.BULLET_SPEED != null:
		
		SPEED = _parent.BULLET_SPEED
		SIZE = _parent.BULLET_SIZE
		DAMAGE = _parent.BULLET_DAMAGE
		default_color = _parent.default_color
		_init = true
		update()


func _draw():
	if _init:
		draw_circle(Vector2.ZERO, SIZE, _parent.default_color)


func set_direction(direction):
	_direction = direction
	randomize()
	_direction += Vector2(randf() / 10, randf() / 10)


func _on_body_entered(body):
	if body.is_a_parent_of(self):
		return
	if body is Character:
		body.apply_velocity((body.global_position - global_position).normalized() * KNOCKBACK_MULTIPLIER * DAMAGE)
		body.take_damage(DAMAGE)
	queue_free()