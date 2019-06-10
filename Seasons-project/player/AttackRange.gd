extends Node2D

export var attack_range = 8

var _parent
var _init
var _up
var _front
var _down

func _ready():
	_parent = get_parent()
	_up = $Up
	_front = $Front
	_down = $Down
	_init = false

func _process(delta):
	if _init:
		return
	
	if _parent.SIZE != null:
		translate(Vector2(_parent.SIZE, 0))
		_up.set_cast_to(Vector2(_parent.SIZE, -_parent.SIZE))
		_front.set_cast_to(Vector2(_parent.SIZE, 0))
		_down.set_cast_to(Vector2(_parent.SIZE, _parent.SIZE))
		update()
		_init = true

#TODO: Fer això bé
func is_enemy_in_range():
	return _up.is_colliding() or _front.is_colliding() or _down.is_colliding()

func _draw():
	if not Global.debug:
		return
	draw_line(_up.position, _up.get_cast_to(), Global.COLOR_RED, 2.0)
	draw_line(_front.position, _front.get_cast_to(), Global.COLOR_RED, 2.0)
	draw_line(_down.position, _down.get_cast_to(), Global.COLOR_RED, 2.0)