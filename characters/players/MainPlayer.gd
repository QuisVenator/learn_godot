extends CharacterBody2D

@export var Projectile : PackedScene

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the horizontal input direction.
	var direction_x = Input.get_axis("ui_left", "ui_right")
	
	# Get the vertical input direction.
	var direction_y = Input.get_axis("ui_up", "ui_down")
	
	# Apply horizontal movement or deceleration.
	if direction_x != 0:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction_y != 0:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	# Normalize the velocity vector if moving diagonally to ensure the speed does not exceed the defined SPEED.
	if direction_x != 0 and direction_y != 0:
		velocity = velocity.normalized() * SPEED

	move_and_slide()

	# Check for mouseclick
	if Input.is_action_just_pressed("click"):
		shoot()


func shoot():
	var p = Projectile.instantiate()
	owner.add_child(p)
	p.direction = self.position.direction_to(get_global_mouse_position())
	p.position = self.position

