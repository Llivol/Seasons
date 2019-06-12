extends Timer
class_name AttackCooldown

var can_attack

var _parent
var _init

func _ready():
	can_attack = true
	_parent = get_parent()
	_init = false

func _process(delta):
	if _init:
		return
	
	if _parent.ATTACK_CD != null:
		set_wait_time(_parent.ATTACK_CD)
		_init = true