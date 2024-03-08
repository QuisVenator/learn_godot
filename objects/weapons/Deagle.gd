extends Node2D

var projectile = preload("res://objects/projectiles/simple_projectile.tscn");
var cooldown = 0.5;
var can_shoot = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	# Make weapon always look at the mouse	
	self.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("click"):
		shoot()

func shoot():
	if !can_shoot:
		return
	
	can_shoot = false
	get_tree().create_timer(cooldown).connect("timeout",Callable(self,"_on_cooldown_timeout"))

	# Start cooldown animation
	get_node("AnimationPlayer").play("cooldown")

	var p = projectile.instantiate()
	get_parent().get_owner().add_child(p)
	p.position = get_node("Muzzle").global_position
	p.direction = get_parent().position.direction_to(get_global_mouse_position())


func _on_cooldown_timeout():
	can_shoot = true
