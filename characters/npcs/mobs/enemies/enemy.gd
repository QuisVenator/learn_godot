extends CharacterBody2D
class_name Enemy

var health := 10

func hit(projectile: Projectile):
    health -= projectile.damage
    if health <= 0:
        queue_free()