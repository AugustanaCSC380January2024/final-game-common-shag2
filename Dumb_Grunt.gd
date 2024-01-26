extends Node3D

signal death_sound_signal

@onready var vision_timer = $Vision_Timer_Grunt
@onready var vision_ray_cast : RayCast3D = $Vision_RayCast_Grunt
@onready var field_of_view = $Field_Of_View
@onready var lebedev_pistol = $Lebedev_Pistol
@onready var dumb_grunt = $"."
@onready var shooting_timer = $Shooting_Timer
@onready var bullet_coordinates = $Bullet_coordinates
@onready var pistol_shot = $Pistol_Shot
@onready var player_detection_area = $Player_Detection_Area


@export var nine_mm_scene : PackedScene
@export var bullet_damage : int
@export var max_grunt_health : int




var current_health: int:
	set(health_in):
		current_health = health_in
		print(current_health)
		if current_health <= 0:
			print("Grunt Died")
			remove_grunt()
			
var body_position : Vector3
var player_in_sight : bool = false
var player_last_position : Vector3
var player_in_detection : bool = false
# Called when the node enters the scene tree for the first time.

func _ready():
	current_health = max_grunt_health
	SignalManager.twig_player_position.connect(turn_to_twig_snap)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_in_sight:
		#self.look_at(Vector3(body_x, body_y,body_z), Vector3.ZERO, true)
		get_new_positions()
		
		#rotation = position.angle_to_point(Vector3(body_x, body_y, body_z))
				
func get_new_positions() -> void:
	var overlaps = field_of_view.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.name == "Player":
				var player_position = overlap.global_transform.origin
				var grunt_pos = global_transform.origin
				player_last_position = player_position
				player_position.y = grunt_pos.y
				look_at(player_position, Vector3.UP, true)
				
				vision_ray_cast.look_at(player_position, Vector3.UP)
				vision_ray_cast.force_raycast_update()


func shoot_player(player_position: Vector3):
	var shot = nine_mm_scene.instantiate()
	shot.global_position = bullet_coordinates.global_position
	shot.position = bullet_coordinates.position
	shot.transform.basis = bullet_coordinates.transform.basis
	add_child(shot)
	pistol_shot.play()

func remove_grunt() -> void:
	SignalManager.grunt_death_sound.emit()
	remove_child(self)
	queue_free()

func _on_field_of_view_body_entered(body):
	if body.is_in_group("player"):
		player_in_sight = true
		shooting_timer.start()
		
		#vision_ray_cast.look_at(body.global_position, Vector3.FORWARD, true)
		#vision_ray_cast.force_raycast_update()
		#var collision_point = vision_ray_cast.get_collision_point()
		#dumb_grunt.look_at(body.global_position, Vector3.UP, true)
		#dumb_grunt.look_at(collision_point, Vector3.UP, true)
		#body_position = body.global_position
		#rapid_cast = true

func _on_field_of_view_body_exited(body):
	if body.is_in_group("player"):
		player_in_sight = false
		shooting_timer.stop()


func _on_shooting_timer_timeout():
	if player_in_sight == true:
		shoot_player(player_last_position)


#For Twig Snap turning
#Certified Working Script
func turn_to_twig_snap(player_pos : Vector3) -> void:
	var grunt_pos = global_transform.origin
	var distance_to = sqrt((player_pos.x - grunt_pos.x) + (player_pos.y - grunt_pos.y) + (player_pos.z - grunt_pos.z))
	
	if distance_to < 30.0:
		player_pos.y = grunt_pos.y
		look_at(player_pos, Vector3.UP, true)
		player_last_position = player_pos
		print(distance_to)
	


func _on_player_detection_area_area_entered(area):
	if area.is_in_group("Enemy_Detector_Area"):
		print("detection activated")
		player_in_detection = true
		


func _on_player_detection_area_area_exited(area):
	if area.is_in_group("Enemy_Detector_Area"):
		player_in_detection = false
		
