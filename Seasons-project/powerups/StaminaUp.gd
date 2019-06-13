extends Powerup

export var value = 50

func _ready():
	._ready()
	default_color = Global.COLOR_GREEN

func _on_body_entered(body):
	if body is Player:
		body.recover_stamina(value)
		queue_free()