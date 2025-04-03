extends enemy
@onready var hitbox: Area3D = $Hitbox
@export var damage: float = 1.0
@export var player: CharacterBody3D
@export var movement_speed: int = 5
@export var aggresion_distance: int = 18
enum states {
IDLE,
CHASE,
KNOCKBACK
}
var current_state = states.IDLE
func _physics_process(delta: float) -> void:
	state_logic(current_state)
	move_and_slide()
func switch_state(old_state, new_state):
	exit_state(old_state)
	enter_state(new_state)
	current_state = new_state

func enter_state(state):
	match state:
		pass
	
func state_logic(state):
	match state:
		states.IDLE:
			var player_distance = position.distance_to(player.position)
			if player_distance < aggresion_distance:
				switch_state(states.IDLE, states.CHASE)
		states.CHASE:
			var player_pos = player.position
			var move_dir = player_pos - position
			velocity = move_dir.normalized() * movement_speed
			print(hitbox.get_overlapping_areas())
			if hitbox.overlaps_area(player.hurtbox):
				player.take_damage(damage, 0.3)
		states.KNOCKBACK:
			if is_on_floor():
				switch_state(states.KNOCKBACK, states.IDLE)
			

func exit_state(state):
	match state:
		pass

func take_damage(damage, Sknockback_strength,Uknockback_strength, attacker):
	hp -= damage
	if hp <= 0:
		die()
	var knockback_dir = position - attacker.position
	var knockback = knockback_dir.normalized() * Sknockback_strength * Vector3(1, 0, 1)
	velocity += knockback
	velocity.y += Uknockback_strength
	switch_state(current_state, states.KNOCKBACK)
