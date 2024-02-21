extends Area2D

const speed : int = 50
var direction : Vector2
var ttl := 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = direction.normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	ttl = ttl - delta
	if ttl <= 0:
		queue_free()
		return
	position += direction * speed * delta + direction * 0.5 * ttl**2
