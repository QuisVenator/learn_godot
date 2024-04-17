extends Enemy
class_name EnemySlime

var player : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	velocity = self.position.direction_to(player.position).normalized() * 6000 * delta
	move_and_slide()
