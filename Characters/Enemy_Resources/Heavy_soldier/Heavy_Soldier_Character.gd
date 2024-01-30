extends CharacterBody3D

var player = null

@export var player_path := "/root/Level_Gen/Player"
@export var starting_health : int = 250
@export var bullet_762 : PackedScene

@onready var player_finder = $Player_Finder
@onready var anim_tree = $Animation_State_Machine
@onready var bullet_coords = $Heavy_Soldier_Master_Scene/RootNode/AKM_scene/Bullet_Coords
@onready var shooting_timer = $shooting_timer
@onready var enemy_hit_sound = $"Enemy Hit Sound"

@onready var shoot_sound = $ShootSound

var state_machine
var is_aiming : bool
var is_half_health : bool
var target_range : float = 25.0
var buffer_distance : float = 10

var current_health: int:
	set(health_in):
		current_health = health_in
		#if current_health / 2 < starting_health and is_half_health == false:
			#Set_hit_animation
		if current_health <= 0:
			SignalManager.grunt_death_sound.emit()
			shooting_timer.stop()
			anim_tree.set("parameters/conditions/is_dead", true)


const SPEED = 4.0

func _ready():
	player = get_node(player_path)
	set_starting_health()
	state_machine = anim_tree.get("parameters/playback")
	anim_tree.set("parameters/conditions/down_to_aiming", true)
	is_aiming = true
func _process(delta):
	velocity = Vector3.ZERO
	match state_machine.get_current_node():
		"Down_To_Aim":
			pass
		"Walking":
			player_finder.set_target_position(player.global_transform.origin)
			var next_nav_point = player_finder.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		"Idle_Aimed":
			player_finder.set_target_position(player.global_transform.origin)
			var next_nav_point = player_finder.get_next_path_position()
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			if !is_target_in_buffer_distance():
				anim_tree.set("parameters/conditions/Left_Buffer", true)
		"Dying":
			pass
	
	
	
	#Conditions
	#anim_tree.set("parameters/conditions/Aim_to-walking", !is_target_in_shooting_range())
	anim_tree.set("parameters/conditions/In_Buffer", is_target_in_buffer_distance())
	anim_tree.set("parameters/conditions/Left_Buffer", !is_target_in_buffer_distance())
	
	
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
		if player != null:
			shooting_timer.start()

func remove_heavy_soldier() -> void:
		SignalManager.grunt_death_sound.emit()
		remove_child(self)
		queue_free()

func _on_shooting_timer_timeout():
	shoot_player(Vector3(player.global_position.x, global_position.y, player.global_position.z))


func _on_animation_state_machine_animation_finished(anim_name):
	if anim_name == "Dying":
		remove_heavy_soldier()


func _on_collision_area_box_area_entered(area):
	if area.is_in_group("bullet_area"):
		current_health -= 18
		enemy_hit_sound.play()
		#queue_free()
		#remove_child(self)

func set_starting_health():
	if SignalManager.difficulty == 1:
		current_health = 200
	elif SignalManager.difficulty == 2:
		current_health = 250
	elif SignalManager.difficulty == 3:
		current_health = 300
