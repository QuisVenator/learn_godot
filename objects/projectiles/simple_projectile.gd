extends Projectile

const speed : int = 80
var direction : Vector2
var ttl := 5.0
var damage = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = direction.normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	ttl = ttl - delta
	if ttl <= 0:
		queue_free()
		return
	position += direction * speed * delta + direction * 0.2 * ttl**2

func _on_body_entered(body):
	if body is Enemy:
		body.hit(self)
