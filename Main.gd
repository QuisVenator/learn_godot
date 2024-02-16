extends Node

var map_size = Vector2i(300, 300)

# Called when the node enters the scene tree for the first time.
func _ready():
	var noise = FastNoiseLite.new()
	var map: TileMap = get_node("Map")
	var grass_tiles = []
	
	for x in range(map_size.x):
		for y in range(map_size.y):
			if noise.get_noise_2d(x, y) > 0:
				grass_tiles.append(Vector2i(x, y))
			else:
				# Delete the cell
				map.set_cell(0,  Vector2i(x, y), -1)

	map.set_cells_terrain_connect(0, grass_tiles, 0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_map_size(map: TileMap) -> Vector2:
	var cells = map.get_used_cells(0)
	if cells.size() == 0:
		return Vector2(0, 0)
	
	var upper_left := Vector2.ZERO
	var lower_right := Vector2.ZERO
	for cell in cells:
		if upper_left == null:
			upper_left = cell
			lower_right = cell
		else:
			upper_left.x = min(upper_left.x, cell.x)
			upper_left.y = min(upper_left.y, cell.y)
			lower_right.x = max(lower_right.x, cell.x)
			lower_right.y = max(lower_right.y, cell.y)
	
	return lower_right - upper_left + Vector2(1, 1)