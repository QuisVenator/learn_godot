extends Timer

@export var Enemies : Array[Spawnable]

enum {TOP, DOWN, LEFT, RIGHT}

var difficulty := 0
var elapsed := 0
var player : CharacterBody2D
var viewport : Vector2
var rng : RandomNumberGenerator
var map : TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	self.start()
	player = owner.get_node("Player")
	var camera = player.get_node("Camera2D")
	viewport = camera.get_viewport_rect().size
	rng = RandomNumberGenerator.new()
	map = owner.get_node("Map")

func _on_timeout() -> void:
	elapsed += 1
	for enemy in Enemies:
		if elapsed % enemy.spawn_interval == 0:
			print("Spawning %s" % enemy.scene)
			var pos := _get_spawn_pos()
			if pos:
				var spawned := enemy.scene.instantiate()
				spawned.global_position = pos
				spawned.player = player
				add_child(spawned)

func _get_spawn_pos() -> Vector2:
	var x := viewport.x / 2
	var y := viewport.y / 2
	var pos : Vector2
	for i in range(5):
		var side := rng.randi_range(0, 3)
		match side:
			TOP:
				pos = player.position + Vector2(randf_range(-0.5 * x, x / 2), -1 * y / 2.0)
			DOWN:
				pos = player.position + Vector2(randf_range(-0.5 * x, x / 2), y / 2.0)
			LEFT:
				pos = player.position + Vector2(x / 2.0, randf_range(-0.5 * y, y / 2))
			RIGHT:
				pos = player.position + Vector2(x / -2.0, randf_range(-0.5 * y, y / 2))
		if (map.get_cell_source_id(1, map.local_to_map(player.position)) == 0):
			return pos
	
	return Vector2.ZERO
