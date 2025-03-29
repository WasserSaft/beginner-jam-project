extends CharacterBody3D
@export var stats: Resource
enum states {
	GROUNDED, 
	LAUNCH,
	FALL,
}
var current_state = states.FALL
@onready var camera: Camera3D = $Head/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	state_logic(current_state)
	movement()
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * stats.sensitivity)
		camera.rotate_x(-event.relative.y * stats.sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5)

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

func movement():
	var movement_direction = Vector3.ZERO
	movement_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	movement_direction.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_up")
# Get camera's basis to rotate movement direction
	var camera_basis = camera.global_transform.basis
# Convert movement direction to match the camera's rotation
	var move_vec = (camera_basis * movement_direction).normalized()
# Ensure movement only affects horizontal plane (no unwanted vertical movement)
	move_vec.y = 0
	move_vec = move_vec.normalized()
# Apply movement velocity
	velocity.x += move_vec.x * stats.move_speed * get_process_delta_time()
	velocity.x -= velocity.x * stats.friction
	velocity.z += move_vec.z * stats.move_speed * get_process_delta_time()
	velocity.z -= velocity.z * stats.friction
