extends Marker3D

var impact = preload( "res://First_Person_Package/fps_controller/abilities/shoot/instances/impact.tscn" )

@export_range(0, 500, 1) var ammo = 30
@export var bullet_762 : PackedScene
@export var rigid_bullet: PackedScene
@onready var ammo_background_color = $Control/AmmoBackground2.color
@onready var akm_scene = $Position3D/AKM_scene
#@onready var ammo_label = %Ammo_Label
@onready var bullet_coords = $Position3D/AKM_scene/Bullet_Coords

@onready var ammo_label = $"../../../../Ammo_Label"


func _ready():
	ammo_label.text = "Ammo: " + str(ammo)

func _process(delta):
	#$BulletSpread/RayCast3D.rotation.x = randf_range(0, deg_to_rad(5)) * $RecoilStabilizationTimer.time_left * 5

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.get_joy_axis(0, JOY_AXIS_TRIGGER_RIGHT) >= 0.6:
		shoot()

	if Input.is_key_pressed(KEY_R) or Input.is_joy_button_pressed(0, JOY_BUTTON_X):
		if ammo != 30:
			ammo_fade_off_animation()
			
			$ReloadTimer.start()
			$Control/AmmoLeft.show()
			ammo = 30
			ammo_label.text = "Ammo: " + str(ammo)

			$ReloadSound.pitch_scale = randf_range(0.95, 1.05)
			$ReloadSound.play()

			var tween = create_tween()
			$Control/AmmoLeft.size.x = 0
			tween.tween_property( $Control/AmmoLeft, "size:x", float(ammo), 1.0 )
			tween.parallel().tween_property( akm_scene, "rotation:x", deg_to_rad(360), 1 ).set_trans(Tween.TRANS_BACK)
			tween.tween_property( akm_scene, "rotation:x", deg_to_rad(0), 0 )

func shoot():
	if not $ReloadTimer.is_stopped():
		return
	if not $FireRateTimer.is_stopped():
		return

	ammo_fade_off_animation()

	$FireRateTimer.start()

	$TriggerSound.pitch_scale = randf_range(0.95, 1.05)
	$TriggerSound.play()

	if ammo <= 0:
		var tween = create_tween()
		tween.tween_property( $Control/AmmoBackground2, "color", Color(1, 1, 1), 0)
		tween.tween_property( $Control/AmmoBackground2, "color", ammo_background_color, 0.1 )
		return

	var tween = create_tween()
	tween.tween_property( akm_scene, "position:z", randf_range(0.035, 0.045), 0.05 ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property( akm_scene, "position:y", randf_range(0.005, 0.015), 0.05 ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property( akm_scene, "position:x", randf_range(-0.005, 0.005), 0.05 ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property( akm_scene, "rotation:x", deg_to_rad( randf_range(-1.5, -0.5) ), 0.05 ).set_trans(Tween.TRANS_SINE)

	tween.tween_property( akm_scene, "position:z", 0.0, 0.15 ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property( akm_scene, "position:y", 0.0, 0.15 ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property( akm_scene, "position:x", 0.0, 0.15 ).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property( akm_scene, "rotation:x", 0.0, 0.15 ).set_trans(Tween.TRANS_SINE)
	
	
	#var shot = projectile.instantiate()
	#	add_child(shot)
	#	shot.global_position = cannon.global_position
	#	#shot.direction = global_transform.basis.z
	#	shot.direction = turret_base.global_transform.basis.z
	#turret_base.look_at(target.global_position, Vector3.UP, true)
	var shot = bullet_762.instantiate()
	shot.global_position = bullet_coords.global_position
	shot.position = bullet_coords.position
	shot.transform.basis = bullet_coords.transform.basis
	add_child(shot)
	
	#SomeWhat_Works
	#shot.global_position = bullet_coords.global_position
	#shot.global_transform.origin.y = bullet_coords.global_transform.origin.y
	#shot.direction = bullet_coords.global_transform.basis.z
	#add_child(shot)
	
	#shot.global_transform.origin.x = akm_scene.global_transform.origin.x
	#shot.global_transform.origin.y = akm_scene.global_transform.origin.
	
	#shot.direction = akm_scene.global_transform.basis.x
	
	#var player_position = overlap.global_transform.origin
	#	var grunt_pos = global_transform.origin
	#	player_position.y = grunt_pos.y
	
	
	#var rigid_shot = rigid_bullet.instantiate()
	#add_child(rigid_shot)
	#rigid_shot.global_position = akm_scene.global_position
	#rigid_shot.direction = akm_scene.global_transform.basis.z
	
	ammo -= 1
	ammo_label.text = "Ammo: " + str(ammo)
	$Control/AmmoLeft.size.x = ammo

	#$BulletSpread.rotation.z = randf_range( 0, deg_to_rad(360) )
	$RecoilStabilizationTimer.start()

	$ShootSound.pitch_scale = randf_range(0.95, 1.05)
	$ShootSound.play()

	$BangSound.pitch_scale = randf_range(0.95, 1.05)
	$BangSound.play()

	$ShellSound.pitch_scale = randf_range(0.95, 1.05)
	$ShellSound.play()

	#if $BulletSpread/RayCast3D.is_colliding():
	#	var impact_instance = impact.instantiate()

	#	get_tree().get_root().add_child(impact_instance)
	#	impact_instance.position = $BulletSpread/RayCast3D.get_collision_point()
	#	impact_instance.rotation = global_transform.basis.get_euler()
		#var collidor = $BulletSpread/RayCast3D.:
		
		
		#if $BulletSpread/RayCast3D.get_collider() is RigidDynamicBody3D:
		#	$BulletSpread/RayCast3D.get_collider().apply_central_impulse( -$BulletSpread/RayCast3D.get_collision_normal() * 20 )

func ammo_fade_off_animation():
	var tween = create_tween()
	tween.tween_property($Control, "modulate", Color(1, 1, 1, 1), 0)
	tween.tween_property($Control, "modulate", Color(1, 1, 1, 0.5), 1).set_trans(Tween.TRANS_SINE)

func fire_bullet() -> Node3D:
	var bullet = bullet_762.instantiate()
	add_child(bullet)
	return bullet
