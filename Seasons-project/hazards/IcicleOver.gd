extends Blocker

func _ready():
	set_stats(Global.SIZE_AVERAGE, Global.HEALTH_HIGH, Global.DAMAGE_AVERAGE, false)

""" Override """
func die():
	print("hey")
	var tile_pos = get_parent().get_node("TileMap").world_to_map(global_position)
	tile_pos -= Vector2.UP
	var tile = get_parent().get_node("TileMap").set_cellv(tile_pos, 13)
	.die()