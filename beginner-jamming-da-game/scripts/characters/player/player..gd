extends CharacterBody3D
@onready var ray_cast_3d: RayCast3D = $Head/RayCast3D
@export var inventory: Inventory
@export var stats: Resource
@export var death_screen: PackedScene

@onready var hud: Control = $CanvasLayer/Hud
@onready var camera: Camera3D = $Head/Camera3D
@onready var animation_player: AnimationPlayer = $Head/Camera3D/UncleFPSHands/AnimationPlayer
@onready var cooldown_timer: Timer = $cooldown_timer
@onready var hitbox: Area3D = $hitbox

const DEATH_SCREEN = preload("res://scenes/important scenes/death_screen.tscn")

var cooldown_time = 1
var bobbing_time := 0.0
var bobbing_amplitude := 0.08 #how high the bobbing goes
var bobbing_frequency := 10.0 #how fast the bobbing happens
var head_original_position: Vector3

enum states { GROUNDED, LAUNCH, FALL, }
var current_state = states.FALL


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	head_original_position = $Head.position

func _input(event):
	#camera movment
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * stats.sensitivity)
		camera.rotate_x(-event.relative.y * stats.sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5)
		# take damage
	if Input.is_action_just_pressed("r"):
		take_damage(1)
	if Input.is_action_just_pressed("interact"):
		interact()
	if Input.is_action_just_pressed("attack"):
		if cooldown_timer.is_stopped():
			attack()
		

func _physics_process(delta: float) -> void:
	var _unused = delta
	state_logic(current_state)
	movement()
	move_and_slide()
	apply_head_bobbing(delta)

#------state functions
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
			apply_gravity()
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
		
#------end of state functions
#------beginning of movement functions
func apply_gravity():
	velocity.y -= stats.gravity * get_process_delta_time()

func movement():
	var movement_direction = Vector3.ZERO
	movement_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	movement_direction.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
#get camera's basis to rotate movement direction
	var camera_basis = camera.global_transform.basis
#converts movement direction to match the camera's rotation
	var move_vec = (camera_basis * movement_direction).normalized()
#movement that affects horizontal plane (no vertical movement)
	move_vec.y = 0
	move_vec = move_vec.normalized()
#movement velocity
	velocity.x += move_vec.x * (stats.move_speed * 0.4) * get_process_delta_time()
	velocity.x -= velocity.x * stats.friction
	velocity.z += move_vec.z * (stats.move_speed * 0.4) * get_process_delta_time()
	velocity.z -= velocity.z * stats.friction

func apply_head_bobbing(delta):
	var is_moving = Input.get_action_strength("move_up") > 0 or Input.get_action_strength("move_down") > 0 or \
	Input.get_action_strength("move_left") > 0 or Input.get_action_strength("move_right") > 0

	if is_on_floor() and is_moving:
		bobbing_time += delta * bobbing_frequency
		var bob_offset = sin(bobbing_time) * bobbing_amplitude
		$Head.position.y = head_original_position.y + bob_offset
	else:
		#reset head position when not moving
		bobbing_time = 0.0
		$Head.position.y = lerp($Head.position.y, head_original_position.y, 10 * delta)
#-----end of movement
func take_damage(damage):
	stats.hp -= damage
	if stats.hp <= 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_packed(DEATH_SCREEN)
	else:
		hud.display_hp()

func interact():
	var collider = ray_cast_3d.get_collider()
	if collider and collider.is_in_group("interactable"):
		var target = collider.get_parent()
		if target.has_method("interact"):
			target.interact(self)
		hud.update_inventory()

func attack():
	animation_player.play("Swing")
	cooldown_timer.start(cooldown_time)
	var enemies = hitbox.get_overlapping_bodies()
	print(enemies)
	for enemy in enemies:
		if enemy.is_in_group("enemies") and enemy.has_method("take_damage"):
			enemy.take_damage(stats.damage)
	
	
	
