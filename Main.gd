extends Node

var chunk_size := Vector2i(16, 16)
var player: CharacterBody2D
var debugText: RichTextLabel
var map: TileMap
var noise: FastNoiseLite

# Called when the node enters the scene tree for the first time.
func _ready():
	debugText = get_node("CanvasLayer/DebugText")
	player = get_node("Player")

	noise = FastNoiseLite.new()
	map = get_node("Map")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_pos: Vector2i = Vector2i(round(player.position.x / 16), round(player.position.y / 16))
	
	var player_chunk = Vector2i(round((player_pos.x - 8) / float(chunk_size.x)), round((player_pos.y - 8) / float(chunk_size.y)))
	debugText.text = "Player position: " + str(player_pos)
	debugText.text += "\nPlayer chunk: " + str(player_chunk)

	renderChunk(player_chunk)

func renderChunk(chunk: Vector2i):
	var grass_tiles = []
	for x in range(chunk_size.x):
		for y in range(chunk_size.y):
			var map_pos := Vector2i(chunk.x * chunk_size.x + x, chunk.y * chunk_size.y + y)
			if noise.get_noise_2d(map_pos.x, map_pos.y) > 0:
				grass_tiles.append(map_pos)
			else:
				# Delete the cell
				map.set_cell(0,  map_pos, 1, Vector2i(0, 0), 0)
	
	map.set_cells_terrain_connect(0, grass_tiles, 0, 0)

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