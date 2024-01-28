extends CharacterBody3D

var player = null

@export var player_path : NodePath

@export var bullet_762 : PackedScene

@onready var player_finder = $Player_Finder
@onready var animation_state_machine = $Animation_State_Machine
@onready var bullet_coords = $Heavy_Soldier_Master_Scene/RootNode/AKM_scene/Bullet_Coords
@onready var shooting_timer = $shooting_timer

@onready var shoot_sound = $ShootSound

#if alert is true, then heavy soldier sees the player
var alert : bool = false
#opposite of alert
var idling : bool

var is_aiming : bool

var target_range : float = 18.8
var buffer_distance : float = 5

const SPEED = 4.0

func _ready():
	player = get_node(player_path)
	idling = true
	#animation_state_machine.set("parameters/conditions/idle", is_idle())
	#Aim_to-walking
	animation_state_machine.set("parameters/conditions/down_to_aiming", true)
	is_aiming = true
func _process(delta):
	if is_aiming:
		
		velocity = Vector3.ZERO
		player_finder.set_target_position(player.global_transform.origin)
		var next_nav_point = player_finder.get_next_path_position()
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		move_and_slide()

func is_idle() -> bool:
	return idling

func is_alert() -> bool:
	return alert

func is_target_in_range() -> bool:
	return global_position.distance_to(player.global_position) < target_range
	
func is_target_in_buffer_distance() -> bool:
	return global_position.distance_to(player.global_position) < buffer_distance

func shoot_player(player_position: Vector3):
	var shot = bullet_762.instantiate()
	shot.global_position = bullet_coords.global_position
	shot.position = bullet_coords.position
	shot.transform.basis = bullet_coords.transform.basis
	add_child(shot)
	shoot_sound.play()
	

func _on_line_of_sight_body_entered(body):
	if body.is_in_group("player"):
		print("I See You")
		alert = true
		if idling == true:
			idling = false
		
		if player != null:
			shooting_timer.start()
			
		else:
			print("player null???")



func _on_shooting_timer_timeout():
	shoot_player(Vector3(player.global_position.x, global_position.y, player.global_position.z))
