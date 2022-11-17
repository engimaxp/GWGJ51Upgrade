extends Node

onready var map = $TileMap
onready var player = $Players

func _ready():
	var map_limits = map.get_used_rect()
	var map_cellsize = map.cell_size * map.scale
	var final_limit = Rect2(map_limits.position.x * map_cellsize.x,map_limits.position.y * map_cellsize.y,\
		map_limits.size.x * map_cellsize.x,map_limits.size.y * map_cellsize.y)
	
	player.world_size = final_limit
