extends Timer

@export var Enemies : Array[Enemy]
var difficulty := 0
var elapsed := 0
var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.start()
	print("hello")
	player = owner.get_node("Player")


func _on_timeout() -> void:
	print(elapsed)
	elapsed += 1
	for enemy in Enemies:
		if elapsed % enemy.spawn_interval == 0:
			var spawned := enemy.scene.instantiate()
			spawned.position = player.position
			add_child(spawned)
