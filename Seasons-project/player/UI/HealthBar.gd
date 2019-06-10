extends TextureProgress

var _parent
var _init

func _ready():
	_parent = get_parent()
	_init = false

func _process(delta):
	if _init:
		return

	if _parent.max_health != null:
		max_value = _parent.max_health
		value = _parent.current_health 
		margin_top = -1 * (_parent.SIZE + 8)
		_init = true

func _on_Player_health_changed(new_value: int) -> void:
	print("break")
	value = new_value
	yield(animate_value(new_value), "completed")


func animate_value(target, tween_duration = 1.0):
	$Tween.interpolate_property(self, 'value', value, target, tween_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")