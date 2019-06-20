extends Powerup

export var value = 1

func _ready():
	._ready()
	default_color = Global.COLOR_RED

func _on_body_entered(body):
	body.recover_health(value)
	queue_free()