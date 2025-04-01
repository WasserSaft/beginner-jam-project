extends CharacterBody3D
class_name enemy
@export var hp: int = 0.2
@export var friction: float

func _physics_process(delta: float) -> void:
	physics_process(delta)

func physics_process(delta: float) -> void:
	apply_friction()
	apply_gravity()
	move_and_slide()


func take_damage(damage, Sknockback_strength,Uknockback_strength, attacker):
	hp -= damage
	if hp <= 0:
		die()
	var knockback_dir = position - attacker.position
	var knockback = knockback_dir.normalized() * Sknockback_strength * Vector3(1, 0, 1)
	velocity += knockback
	velocity.y += Uknockback_strength
		
func die():
	queue_free()

func apply_gravity():
	velocity.y -= 1

func apply_friction():
	velocity.x -= velocity.x * friction
	velocity.z -= velocity.z * friction
