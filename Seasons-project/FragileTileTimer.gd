extends Timer
class_name FragileTileTimer

var tile_pos
var tilemap

func set_tile_pos(tile_pos):
	self.tile_pos = tile_pos


func set_tilemap(tilemap):
	self.tilemap = tilemap


func _on_timeout():
	tilemap.set_cellv(tile_pos, -1)
	queue_free()