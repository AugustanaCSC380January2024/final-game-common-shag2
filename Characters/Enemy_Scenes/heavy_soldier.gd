extends Node3D

@onready var field_of_view = $Field_of_view
@onready var vision_ray_cast = $Vision_RayCast

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_vision_timer_timeout():
	var overlaps = field_of_view.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.name == "Player":
				var player_position = overlap.global_transfornm.origin
				vision_ray_cast.look_at(player_position, Vector3.UP)
				vision_ray_cast.force_raycast_update()
				
				if vision_ray_cast.is_colliding():
					var collidor = vision_ray_cast.get_collider()
					
					if collidor.name == "Player":
						print("I see you")
