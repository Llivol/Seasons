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
		if _parent.is_on_floor() or (_parent.get_input("right") or _parent.get_input("left")):
			show()
		else:
			hide()
		if _parent.states_strings[_parent.get_state()] == "exhausted":
			hide()
		if !Cheats.debug:
			hide()
		return
	
	if _parent.SIZE != null:
		var sprite_size = _parent.get_sprite_size()
		translate(Vector2(_parent.get_sprite_size().x / 2 + 1, 0))
		_up.translate(Vector2(0, -_parent.get_sprite_size().y / 4))
		_up.set_cast_to(Vector2(_parent.get_sprite_size().x, -_parent.get_sprite_size().y / 4))
		_front.set_cast_to(Vector2(_parent.get_sprite_size().x, 0))
		_down.translate(Vector2(0, _parent.get_sprite_size().y / 4))
		_down.set_cast_to(Vector2(_parent.get_sprite_size().x, _parent.get_sprite_size().y / 4))
		update()
		_init = true


func is_enemy_in_range():
	return _up.is_colliding() or _front.is_colliding() or _down.is_colliding()


func get_enemy_in_range():
	if _front.is_colliding():
		return _front.get_collider()
	elif _up.is_colliding():
		return _up.get_collider()
	elif _down.is_colliding():
		return _down.get_collider()
	else:
		return null


func _draw():
	if not Cheats.debug:
		return
	draw_line(_up.position, _up.get_cast_to(), Global.COLOR_RED, 1.0)
	draw_line(_front.position, _front.get_cast_to(), Global.COLOR_RED, 1.0)
	draw_line(_down.position, _down.get_cast_to(), Global.COLOR_RED, 1.0)