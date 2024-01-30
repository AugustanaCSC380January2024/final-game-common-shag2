extends Node3D

signal death_sound_signal

@onready var field_of_view = $Field_Of_View
@onready var turret = $"."
@onready var shooting_timer = $Shooting_Timer
@onready var bullet_coordinates = $Bullet_coordinates
@onready var pistol_shot = $Pistol_Shot
@onready var explosion_sfx = $"Explosion sfx"
@onready var death_timer = $Death_timer
@onready var shooting_turret_timer = $shooting_turret_timer
@onready var explosion_particles = $ExplosionParticles
@onready var line_of_sight = $Line_of_sight

@export var nine_mm_scene : PackedScene
@export var bullet_damage : int
@export var max_turret_health : int


var current_health: int:
	set(health_in):
		current_health = health_in
		if current_health <= 0:
			remove_turret()
			
var body_position : Vector3
var player_in_sight : bool = false
var player_last_position : Vector3
var player_in_detection : bool = false

func _ready():
	set_start_health()
	SignalManager.twig_player_position.connect(turn_to_twig_snap)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_sight:
		#self.look_at(Vector3(body_x, body_y,body_z), Vector3.ZERO, true)
		get_new_positions()
		
				
func get_new_positions() -> void:
	var overlaps = line_of_sight.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.name == "Player":
				var player_position = overlap.global_transform.origin
				var turret_pos = global_transform.origin
				player_last_position = player_position
				player_position.y = turret_pos.y
				look_at(player_position, Vector3.UP, true)


func shoot_player(player_position: Vector3):
	var shot = nine_mm_scene.instantiate()
	shot.global_position = bullet_coordinates.global_position
	shot.position = bullet_coordinates.position
	shot.transform.basis = bullet_coordinates.transform.basis
	add_child(shot)
	pistol_shot.play()

func remove_turret() -> void:
	if !explosion_particles.emitting:
		explosion_particles.emitting = true
	if !explosion_sfx.playing:
		explosion_sfx.play()
		death_timer.start()
#	remove_child(self)
#	queue_free()
	#SignalManager.grunt_death_sound.emit()









#For Twig Snap turning
#Certified Working Script
func turn_to_twig_snap(player_pos : Vector3) -> void:
	var turret_pos = global_transform.origin
	var distance_to = sqrt((player_pos.x - turret_pos.x) + (player_pos.y - turret_pos.y) + (player_pos.z - turret_pos.z))
	
	if distance_to < 30.0:
		player_pos.y = turret_pos.y
		look_at(player_pos, Vector3.UP, true)
		player_last_position = player_pos
	






func _on_shooting_turret_timer_timeout():
	if player_in_sight == true:
		shoot_player(player_last_position)


func _on_enemy_hitbox_area_area_entered(area):
	if area.is_in_group("Enemy_Detector_Area"):
		player_in_detection = true
	if area.is_in_group("bullet_area"):
		current_health -= 18

func _on_enemy_hitbox_area_area_exited(area):
	if area.is_in_group("Enemy_Detector_Area"):
		player_in_detection = false
	


func _on_line_of_sight_body_entered(body):
	if body.is_in_group("player"):
		player_in_sight = true
		shooting_turret_timer.start()


func _on_line_of_sight_body_exited(body):
	if body.is_in_group("player"):
		player_in_sight = false
		shooting_turret_timer.stop()

func set_start_health():
	if SignalManager.difficulty == 1:
		current_health = 125
	elif SignalManager.difficulty == 2:
		current_health = 175
	elif SignalManager.difficulty == 3:
		current_health = 225


func _on_death_timer_timeout():
	turret.queue_free()
	remove_child(turret)
	remove_child(self)
	queue_free()

