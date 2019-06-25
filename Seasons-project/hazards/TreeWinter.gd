extends Blocker

var has_fruits

func _ready():
	has_fruits = false
	set_stats(Global.SIZE_LARGE, Global.HEALTH_HIGH, 0, false)

func _on_AttackArea_body_entered(body):
	if has_fruits:
		$Sprite.set_texture(load("res://_src/hazards/hazards_tree_1.png"))
		randomize()
		body.recover_health(randi()%4+1)
		has_fruits = false