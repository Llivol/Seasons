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
		translate(Vector2(_parent.SIZE + 1, 0))
		_up.translate(Vector2(0, -_parent.SIZE / 2))
		_up.set_cast_to(Vector2(_parent.SIZE*2, -_parent.SIZE / 2))
		_front.set_cast_to(Vector2(_parent.SIZE*2, 0))
		_down.translate(Vector2(0, _parent.SIZE / 2))
		_down.set_cast_to(Vector2(_parent.SIZE*2, _parent.SIZE / 2))
		update()
		_init = true


func is_enemy_in_range():
	return _up.get_collider() is Enemy or _front.get_collider() is Enemy or _down.get_collider() is Enemy


func get_enemy_in_range():
	var algo_up = _up.get_collider()
	var algo_front = _front.get_collider()
	var algo_down = _down.get_collider()
	if _front.get_collider() is Enemy:
		return _front.get_collider()
	elif _up.get_collider() is Enemy:
		return _up.get_collider()
	elif _down.get_collider() is Enemy:
		return _down.get_collider()
	else:
		return null


func _draw():
	if not Global.debug:
		return
	draw_line(_up.position, _up.get_cast_to(), Global.COLOR_RED, 2.0)
	draw_line(_front.position, _front.get_cast_to(), Global.COLOR_RED, 2.0)
	draw_line(_down.position, _down.get_cast_to(), Global.COLOR_RED, 2.0)