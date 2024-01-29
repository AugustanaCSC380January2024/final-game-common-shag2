extends CharacterBody3D

var player = null

@export var player_path : NodePath
@export var starting_health : int = 250
@export var bullet_762 : PackedScene

@onready var player_finder = $Player_Finder
@onready var anim_tree = $Animation_State_Machine
@onready var bullet_coords = $Heavy_Soldier_Master_Scene/RootNode/AKM_scene/Bullet_Coords
@onready var shooting_timer = $shooting_timer

@onready var shoot_sound = $ShootSound

#if alert is true, then heavy soldier sees the player
var alert : bool = false
#opposite of alert

var state_machine
var is_aiming : bool
var is_half_health : bool
var target_range : float = 18.8
var buffer_distance : float = 5

var current_health: int:
	set(health_in):
		current_health = health_in
		print("damaged")
		#if current_health / 2 < starting_health and is_half_health == false:
			#Set_hit_animation
		if current_health <= 0:
			SignalManager.grunt_death_sound.emit()
			anim_tree.set("parameters/conditions/Walking_to_dead", true)
			anim_tree.set("parameters/conditions/dead_down_to_aim", true)
			anim_tree.set("parameters/conditions/Shoot_to_dead", true)

const SPEED = 2.0

func _ready():
	player = get_node(player_path)
	current_health = starting_health
	state_machine = anim_tree.get("parameters/playback")
	anim_tree.set("parameters/conditions/down_to_aiming", true)
	is_aiming = true
func _process(delta):
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"Down_To_Aim":
			pass
		"Walking_Aimed":
			player_finder.set_target_position(player.global_transform.origin)
			var next_nav_point = player_finder.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		"Idle_Shooting":
			player_finder.set_target_position(player.global_transform.origin)
			var next_nav_point = player_finder.get_next_path_position()
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		"Dying":
			pass
	
	
	
	#Conditions
	#anim_tree.set("parameters/conditions/Aim_to-walking", !is_target_in_shooting_range())
	anim_tree.set("parameters/conditions/target_in_range", is_target_in_shooting_range())
	anim_tree.set("parameters/conditions/target_not_in_buffer", !is_target_in_buffer_distance())
	
	
	move_and_slide()


func target_between_ranges() -> bool:
	return is_target_in_shooting_range() and !is_target_in_buffer_distance()

func is_target_in_shooting_range() -> bool:
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
		if player != null:
			shooting_timer.start()
			
		else:
			print("player null???")

func remove_heavy_soldier() -> void:
		remove_child(self)
		queue_free()

func _on_shooting_timer_timeout():
	shoot_player(Vector3(player.global_position.x, global_position.y, player.global_position.z))


func _on_animation_state_machine_animation_finished(anim_name):
	if anim_name == "Dying":
		remove_heavy_soldier()


func _on_collision_area_box_area_entered(area):
	if area.is_in_group("bullet_area"):
		area.get_parent().get_parent().current_health -= 18
		queue_free()
		remove_child(self)
