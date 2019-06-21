extends TextureProgress

var _parent
var _init

func _ready():
	_parent = get_parent()
	_init = false
	
	if _parent is Enemy and not Cheats.debug:
		_init = true
		hide()

func _process(delta):
	if _init:
		if Cheats.debug:
			show()
		if _parent is Enemy and not Cheats.debug:
			hide()
		return

	if _parent.MAX_HEALTH != null:
		max_value = _parent.MAX_HEALTH
		value = _parent.get_health()
		if get_parent().has_node("StaminaBar"):
			margin_top = -1 * (_parent.get_sprite_size().y + 8)
		else:
			margin_top = -1 * (_parent.get_sprite_size().y + (4 * _parent.get_size_multiplier()))
		_init = true

func _on_health_changed(new_value: int) -> void:
	value = new_value
	yield(animate_value(new_value), "completed")

func update_max_health():
	max_value = _parent.MAX_HEALTH

func animate_value(target, tween_duration = 1.0):
	$Tween.interpolate_property(self, 'value', value, target, tween_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")

func _on_flip(direction):
	set_fill_mode(FILL_LEFT_TO_RIGHT) if (direction == 1) else set_fill_mode(FILL_RIGHT_TO_LEFT)

