extends Node3D

@onready var healthkit_scene = $Cell_With_Item/Wooden_Box/healthkit_scene
@onready var pick_up_area = $Cell_With_Item/Wooden_Box/healthkit_scene/pick_up_area

var player : CharacterBody3D

func _on_pick_up_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		if !player.is_connected("pick_up_health", health_picked_up):
			player.connect("pick_up_health", health_picked_up)
		
func health_picked_up():
	healthkit_scene.visible = false
	pick_up_area.remove_from_group("health_pickup_area")
