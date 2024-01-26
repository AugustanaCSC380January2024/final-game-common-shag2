extends Node3D
#certified working script
@onready var gas_can = $Gas_Can_Cell/Gas_Can
@onready var pick_up_area = $Gas_Can_Cell/Gas_Can/Pick_Up_Area

var player : CharacterBody3D

func can_picked_up():
	gas_can.visible = false
	pick_up_area.remove_from_group("gas_can_area")


func _on_pick_up_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		if !player.is_connected("deposit_gas_can_to_car", can_picked_up):
			player.connect("deposit_gas_can_to_car", can_picked_up)

