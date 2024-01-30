extends CharacterBody3D

@export_range(6, 10, 0.5) var run_speed = 8.0
@export_range(6.5, 8, 0.5) var jump_velocity = 6.5
@export_range(0, 10, 1) var air_jumps = 0
@export_range(1, 3, 1) var gravity_multiplier = 2.0
@export var health_pack_heal : int
@export var max_player_health : int = 300

signal deposit_gas_can_to_car
signal pick_up_health
signal turn_to_player
@onready var player_body = $"."
@onready var gas_can_standalone = $Gas_Can_Standalone
@onready var ammo_label = $Ammo_Label
@onready var health_label = $Health_Label
@onready var rambo_skin = $Rambo_Skin
@onready var grab_area = $Grab_Area
@onready var player_hitbox = $Player_Hitbox
@onready var pause_menu = $"Head/Camera3D/Pause Menu"
@onready var healed = $Healed

@onready var death_sound_grunt = $"Death Sound Grunt"
var is_paused : bool = false

var holding_gas_can : bool = false



var current_health: int:
	set(health_in):
		current_health = health_in
		health_label.text = "Health: " + str(current_health)
		if current_health <= 0:
			print("Game Over")
		
var current_speed = run_speed
var remaining_air_jumps = air_jumps

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier

var on_ground = false

var landing_velocity = 0.0

var distance_per_frame = global_transform.origin
var distance_total = 0.0
var previous_position = global_transform.origin

var weapon_sway_amount = 10
var mouse_relative_x = 0
var mouse_relative_y = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	rotation.x = 0
	rotation.z = 0
	current_health = max_player_health
	$Head/Camera3D/DirectionIndicator.hide()
	SignalManager.grunt_death_sound.connect(play_grunt_death_sound)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / 1000
		$Head/Camera3D.rotation.x -= event.relative.y / 1000
		$Head/Camera3D.rotation.x = clamp( $Head/Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
		
#	Getting the mouse movement for the weapon sway in the physics process
	if event is InputEventMouseMotion:
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 10)

func _physics_process(delta):
	#Pause Menu
	if Input.is_action_just_pressed("Pause"):
		pauseMenu()
	
	# Sway
	$Head/Camera3D/Abilities.rotation.y = lerp($Head/Camera3D/Abilities.rotation.y, deg_to_rad(-mouse_relative_x / 40), weapon_sway_amount * delta)
	$Head/Camera3D/Abilities.rotation.x = lerp($Head/Camera3D/Abilities.rotation.x, deg_to_rad(-mouse_relative_y / 20), weapon_sway_amount * delta)
	
	if Input.get_joy_axis(0, JOY_AXIS_RIGHT_X) < -0.2 or Input.get_joy_axis(0, JOY_AXIS_RIGHT_X) > 0.2:
		rotation.y -= deg_to_rad( Input.get_joy_axis(0, 2) * 4.3 )
	if Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y) < -0.2 or Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y) > 0.2:
		$Head/Camera3D.rotation.x -= deg_to_rad( Input.get_joy_axis(0, 3) * 4.3 )

	if not is_on_floor():
		velocity.y -= gravity * delta
		if remaining_air_jumps > 0:
			if not $UncrouchRayCast3D.is_colliding():
				if ( Input.is_action_just_pressed("ui_accept") or Input.is_joy_button_pressed(0, JOY_BUTTON_A) ):
					if remaining_air_jumps > 0:
						remaining_air_jumps -= 1
						velocity.y = jump_velocity
						print("air jumps remaining: ", remaining_air_jumps)
	else:
		remaining_air_jumps = air_jumps
		if not $UncrouchRayCast3D.is_colliding():
			if ( Input.is_action_just_pressed("ui_accept") or Input.is_joy_button_pressed(0, JOY_BUTTON_A) ):
				velocity.y = jump_velocity
				$JumpSound.play()
	if $UncrouchRayCast3D.is_colliding():
		remaining_air_jumps = 0
		
	# Get the input direction and handle the movement/deceleration
	var input_dir = Vector2()
	if Input.is_action_pressed("Forward"):
		input_dir.y = -1
		#print("forwards")
	if Input.is_action_pressed("Backwards"):
		input_dir.y = 1
		#print("backwards")
	if Input.is_action_pressed("Move_Left"):
		input_dir.x = -1
		#print("left")
	if Input.is_action_pressed("Move_Right"):
		input_dir.x = 1
		#print("right")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if input_dir == Vector2():
		if Input.get_joy_axis(0, JOY_AXIS_LEFT_X) < -0.2 or Input.get_joy_axis(0, JOY_AXIS_LEFT_X) > 0.2:
			input_dir.x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
		if Input.get_joy_axis(0, JOY_AXIS_LEFT_Y) < -0.2 or Input.get_joy_axis(0, JOY_AXIS_LEFT_Y) > 0.2:
			input_dir.y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	if is_on_floor():
		current_speed = (run_speed / 2) * $CollisionShape3D.shape.height
	else:
		current_speed = run_speed

	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()

	if Input.is_action_just_pressed("Grab_Item"):
		var overlaps = grab_area.get_overlapping_areas()
		for overlap in overlaps:
			if overlap.is_in_group("gas_can_area"):
				print("Gas Can Grabbed")
				holding_gas_can = true
				gas_can_standalone.visible = true
				healed.play()
				
				deposit_gas_can_to_car.emit()
				#SignalManager.emit_signal("pick_up_gas_can")
				
			if overlap.is_in_group("interact"):
				if holding_gas_can == true:
					print("Filling Car...")
					gas_can_standalone.visible = false
					SignalManager.emit_signal("deposit_gas_can")
					holding_gas_can = false
					
			if overlap.is_in_group("health_pickup_area"):
				pick_up_health.emit()
				current_health += health_pack_heal

	if is_on_floor():
		footstep_sound(true)
		if on_ground == false:
			print("landing velocity: " , landing_velocity)
			$LandSound.play()
			on_ground = true
	else:
		footstep_sound(false)
		on_ground = false
		if not  velocity.y >= 0:
			landing_velocity = -velocity.y

	if Input.is_key_pressed(KEY_CTRL) or Input.is_joy_button_pressed(0, JOY_BUTTON_B):
		crouch(delta)
		return
	
	if is_on_floor():
		uncrouch(delta)
	else:
		crouch(delta)

func footstep_sound(add):
	if add:
		distance_per_frame = global_transform.origin - previous_position
		previous_position = global_transform.origin
		distance_total += distance_per_frame.length()
		if distance_total >= 2:
			distance_total = 0
			$FootstepSound.pitch_scale = randf_range(0.9, 1.1)
			$FootstepSound.play()
	else:
		distance_total = 0

func crouch(delta):
	$CollisionShape3D.shape.height = lerp( $CollisionShape3D.shape.height, 1.5, 10 * delta )
	$CollisionShape3D.position.y = lerp( $CollisionShape3D.position.y, 0.25, 10 * delta )
	#$MeshInstance3D.mesh.height = $CollisionShape3D.shape.height
	#$MeshInstance3D.position.y = $CollisionShape3D.position.y
	
func uncrouch(delta):
	if not $UncrouchRayCast3D.is_colliding():
		$CollisionShape3D.shape.height = lerp( $CollisionShape3D.shape.height, 2.0, 10 * delta )
		$CollisionShape3D.position.y = lerp( $CollisionShape3D.position.y, 0.0, 10 * delta )
		#$MeshInstance3D.mesh.height = $CollisionShape3D.shape.height
		#$MeshInstance3D.position.y = $CollisionShape3D.position.y


func _on_player_hitbox_area_entered(area):
	if area.is_in_group("bullet_area_collidor"):
		current_health += -13
	if area.is_in_group("bullet_area_762"):
		current_health += -18
	#if area.is_in_group("twig_cell_area"):
	#	player_body.add_to_group("Twig_Snapped")
	#	print("Twig Snapped Group Added")
		#turn_to_player.emit(global_position)
		
		
func play_grunt_death_sound():
	death_sound_grunt.play()
	
func pauseMenu():
	if is_paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	is_paused = !is_paused
