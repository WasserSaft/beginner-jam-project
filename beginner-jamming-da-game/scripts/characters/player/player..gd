extends CharacterBody3D

@export var inventory_template: Inventory
@export var stats: Resource
@export var death_screen: PackedScene
@onready var hurtbox: Area3D = $hurtbox
@onready var ray_cast_3d: RayCast3D = $Head/Camera3D/RayCast3D
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

@onready var hud: Control = $CanvasLayer/Hud
@onready var camera: Camera3D = $Head/Camera3D
@onready var animation_player: AnimationPlayer = $Head/Camera3D/UncleFPSHands/AnimationPlayer
@onready var cooldown_timer: Timer = $cooldown_timer
@onready var hitbox: Area3D = $hitbox
@onready var damage_delay: Timer = $damage_delay
@onready var invincible_timer: Timer = $"invincible timer"

const DEATH_SCREEN = preload("res://scenes/important scenes/death_screen.tscn")
var invincible = false
var cooldown_time = 0.75
var bobbing_time := 0.0
var bobbing_amplitude := 0.08 #how high the bobbing goes
var bobbing_frequency := 10.0 #how fast the bobbing happens
var head_original_position: Vector3
var inventory: Inventory 

enum states { GROUNDED, LAUNCH, FALL, }
var current_state = states.FALL


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	head_original_position = $Head.position
	inventory = inventory_template.duplicate(true)

func _input(event):
	#camera movment
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * stats.sensitivity)
		camera.rotate_x(-event.relative.y * stats.sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5)
		# take damage
	if Input.is_action_just_pressed("r"):
		take_damage(1, 0.01)
	if Input.is_action_just_pressed("interact"):
		interact()
	if Input.is_action_just_pressed("attack"):
		if cooldown_timer.is_stopped():
			animation_player.play("Swing")
			cooldown_timer.start(cooldown_time)
			damage_delay.start(2.25/4)
			await damage_delay.timeout
			attack()

func _physics_process(delta: float) -> void:
	var moving = false	
	var _unused = delta
	state_logic(current_state)
	movement()
	move_and_slide()
	apply_head_bobbing(delta)
	var movement_directionX = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var movement_directionZ = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	if movement_directionX != 0 or movement_directionZ != 0:
		moving = true
	if moving == true and is_on_floor() and audio_stream_player_3d.is_playing() == false:
		audio_stream_player_3d.play()
	elif moving != true or is_on_floor() == false:
		audio_stream_player_3d.stop()


#------state functionss
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
	var movement_multiplier = 1
	if Input.is_action_pressed("sprint"):
		movement_multiplier = 1.5
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
	velocity.x += move_vec.x * (stats.move_speed * 0.4) * get_process_delta_time() * movement_multiplier
	velocity.x -= velocity.x * stats.friction 
	velocity.z += move_vec.z * (stats.move_speed * 0.4) * get_process_delta_time() * movement_multiplier
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
func take_damage(damage, invincible_time):
	if invincible == false:
		stats.hp -= damage
		if stats.hp <= 0:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene_to_packed(DEATH_SCREEN)
		else:
			hud.display_hp()
			invincible = true
			invincible_timer.start(invincible_time)

func interact():
	var dialog_ui = get_tree().get_first_node_in_group("dialog_ui")
	if dialog_ui and dialog_ui.visible:
		return  #dialogue is active, block interaction

	var collider = ray_cast_3d.get_collider()
	if collider and collider.is_in_group("interactable"):
		var target = collider.get_parent()
		if target.has_method("interact"):
			target.interact(self)

func attack():
	cooldown_timer.start(cooldown_time)
	var enemies = hitbox.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.is_in_group("enemies") and enemy.has_method("take_damage"):
			enemy.take_damage(stats.damage, stats.sideway_knockback_strength, stats.upward_knockback_strength, self)
	
	
	


func _on_invincible_timer_timeout() -> void:
	invincible = false
