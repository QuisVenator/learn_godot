extends Node

var chunk_size := Vector2i(16, 16)
var player: CharacterBody2D
var debugText: RichTextLabel
var map: TileMap
var noise: FastNoiseLite
var activeChunks: Dictionary = {}
var renderDistance := 3
var chunkRenderQueue: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	debugText = get_node("CanvasLayer/DebugText")
	player = get_node("Player")

	noise = FastNoiseLite.new()
	map = get_node("Map")
	map.add_layer(-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_pos: Vector2i = Vector2i(round(player.position.x / 16), round(player.position.y / 16))
	
	var player_chunk = Vector2i(round((player_pos.x - 8) / float(chunk_size.x)), round((player_pos.y - 8) / float(chunk_size.y)))
	debugText.text = "FPS is: " + str(Engine.get_frames_per_second())
	debugText.text += "\nPlayer position: " + str(player_pos)
	debugText.text += "\nPlayer chunk: " + str(player_chunk)


	for x_offset in range(-1 * renderDistance, renderDistance+1):
		for y_offset in range(-1 * renderDistance, renderDistance+1):
			var visible_chunk = Vector2i(player_chunk.x + x_offset, player_chunk.y + y_offset)
			if activeChunks.has(visible_chunk) == false:
				activeChunks[visible_chunk] = null

				for chunk in activeChunks.keys():
					if abs(chunk.x - player_chunk.x) > renderDistance or abs(chunk.y - player_chunk.y) > renderDistance: 
						delete_chunk(chunk)
						activeChunks.erase(chunk)
				
				chunkRenderQueue.append(visible_chunk)
	
	if chunkRenderQueue.size() > 0:
		render_chunk(chunkRenderQueue.pop_front())

func render_chunk(chunk: Vector2i):
	var grass_tiles = []
	for x in range(chunk_size.x):
		for y in range(chunk_size.y):
			var map_pos := Vector2i(chunk.x * chunk_size.x + x, chunk.y * chunk_size.y + y)
			if noise.get_noise_2d(map_pos.x, map_pos.y) > 0:
				grass_tiles.append(map_pos)
			else:
				map.set_cell(1,  map_pos, 1, Vector2i(0, 0))
			map.set_cell(0,  map_pos, 1, Vector2i(1, 0))
	
	map.set_cells_terrain_connect(1, grass_tiles, 0, 0)

func delete_chunk(chunk: Vector2i):
	for x in range(chunk_size.x):
		for y in range(chunk_size.y):
			var map_pos := Vector2i(chunk.x * chunk_size.x + x, chunk.y * chunk_size.y + y)
			map.set_cell(0,  map_pos, -1)
