extends CharacterBody3D
@export var stats: Resource

enum states {
	GROUNDED, 
	LAUNCH,
	FALL,
}

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	state_logic(current_state)
	move_and_slide()
	print(velocity.y)


var current_state = states.FALL

func switch_state(old_state, new_state):
	exit_state(old_state)
	enter_state(new_state)
	current_state = new_state
	
func enter_state(state):
	match state:
		states.LAUNCH:
			velocity.y += stats.jump_strength
	
func state_logic(state):
	match state:
		states.GROUNDED:
			if Input.is_action_just_pressed("jump"):
				switch_state(states.GROUNDED, states.LAUNCH)
		states.LAUNCH:
			apply_gravity()
			if velocity.y <= 0:
				switch_state(states.LAUNCH, states.FALL)
		states.FALL:
			apply_gravity()
			if is_on_floor():
				switch_state(states.FALL, states.GROUNDED)
				
func exit_state(state):
	match state:
		pass
		
func apply_gravity():
	velocity.y -= stats.gravity * get_process_delta_time()
