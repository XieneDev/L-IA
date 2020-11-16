extends Node2D

const tilemap_objects = [
	[1, preload("res://Objects/Spike.tscn"), Vector2(16, 16)],
	[2, preload("res://Objects/Sawblade.tscn"), Vector2(16, 16)],
	[3, preload("res://Objects/Lever.tscn"), Vector2(16, 16)],
	[4, preload("res://Objects/Door.tscn"), Vector2(16, 32)],
	[5, preload("res://Objects/Plate.tscn"), Vector2(32, 16)],
	[6, preload("res://Objects/FloorDoor.tscn"), Vector2(32, 16)],
	[7, preload("res://Objects/LevelEnd.tscn"), Vector2(32, 32)]
]

func open(tilemap: TileMap) -> void:
	var size = tilemap.get_cell_size()
	var uc := tilemap.get_used_cells()
	for pos in uc:
		var id := tilemap.get_cellv(pos)
		var sub_coord = tilemap.get_cell_autotile_coord(pos.x, pos.y)
		var tilemap_position = Vector2(pos.x * size.x + (0.5*size.x), pos.y * size.y + (0.5*size.y))
		
		for k in tilemap_objects:
			if id == k[0]:
				var obj = k[1].instance()
				obj.sub_coord = sub_coord
				obj.position = tilemap_position + (k[2]/2 - Vector2(8, 8))
				get_tree().current_scene.call_deferred("add_child", obj)
				tilemap.set_cellv(pos, -1)
