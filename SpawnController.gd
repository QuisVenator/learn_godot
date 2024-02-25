extends Timer

@export var Enemies : Array[Enemy]

enum {TOP, DOWN, LEFT, RIGHT}

var difficulty := 0
var elapsed := 0
var player : CharacterBody2D
var viewport : Vector2
var rng : RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	self.start()
	player = owner.get_node("Player")
	var camera = player.get_node("Camera2D")
	viewport = camera.get_viewport_rect().size
	rng = RandomNumberGenerator.new()


func _on_timeout() -> void:
	elapsed += 1
	for enemy in Enemies:
		if elapsed % enemy.spawn_interval == 0:
			var spawned := enemy.scene.instantiate()
			spawned.position = _get_spawn_pos()
			spawned.player = player
			add_child(spawned)

func _get_spawn_pos() -> Vector2:
	var side := rng.randi_range(0, 3)
	match side:
		TOP:
			return player.position + Vector2(randf_range(-0.5 * viewport.x, viewport.x / 2), -1 * viewport.y / 2.0)
		DOWN:
			return player.position + Vector2(randf_range(-0.5 * viewport.x, viewport.x / 2), viewport.y / 2.0)
		LEFT:
			return player.position + Vector2(viewport.x / 2.0, randf_range(-0.5 * viewport.x, -1 * viewport.x / 2))
		RIGHT:
			return player.position + Vector2(viewport.x / 2.0, randf_range(-0.5 * viewport.x, viewport.x / 2))
	# TODO error here
	return player.position