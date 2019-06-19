extends TextureProgress

var _parent
var _init

func _ready():
	_parent = get_parent()
	_init = false

func _process(delta):
	if _init:
		return

	if _parent.MAX_STAMINA != null:
		max_value = _parent.MAX_STAMINA
		value = _parent.get_stamina()
		margin_top = -1 * (_parent.get_sprite_size().y + 2)
		_init = true

func _on_stamina_changed(new_value: int) -> void:
	value = new_value
	yield(animate_value(new_value), "completed")


func animate_value(target, tween_duration = 1.0):
	$Tween.interpolate_property(self, 'value', value, target, tween_duration, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")

func _on_flip(direction):
	set_fill_mode(FILL_LEFT_TO_RIGHT) if (direction == 1) else set_fill_mode(FILL_RIGHT_TO_LEFT)