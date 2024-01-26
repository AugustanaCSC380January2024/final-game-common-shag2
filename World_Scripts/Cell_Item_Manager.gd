extends Node

@export var minimum_Ak : int
@export var minimum_flashlight : int
@export var minimum_night_vision_goggles : int
#@export var blank_cells : int
#@export var item_array: Array

#@onready var flashlight_object = $Wooden_Box/Flashlight_Object
#@onready var night_vision_goggles = $Wooden_Box/Night_Vision_Goggles
#@onready var AK = $"Wooden_Box/AK-47"

var item_Array : Array = ["flashLight", "night_vision_goggles", "ak"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#while minimum_Ak + minimum_flashlight + minimum_night_vision_goggles > get_tree().get_nodes_in_group("blank_cell").size():
	#	set_minimums()
	#for child in get_tree().get_nodes_in_group("blank_cell"):
	#	if child.has_item == false:
	#		child.item = pick_item(child)
	#		child.has_item = true
	#		child.show_item()

func pick_item(child : MeshInstance3D) -> String:
	if minimum_flashlight > get_tree().get_nodes_in_group("cell_with_flashlight").size():
		child.get_tree().add_to_group("cell_with_flashlight")
		#child.flashlight_object.visible = true
		child.remove_from_group("blank_cell")
		print("FlashLight")
		return "Flashlight"
	elif minimum_night_vision_goggles > get_tree().get_nodes_in_group("cell_with_goggles").size():
		child.add_to_group("cell_with_goggles")
		child.remove_from_group("blank_cell")
		print("Night Vision Goggles")
		return "Night_Vision_Goggles"
	elif minimum_Ak > get_tree().get_nodes_in_group("cell_with_AK").size():
		child.add_to_group("AK")
		child.remove_from_group("blank_cell")
		print("Ak-47")
		return "AK"
	else:
		var random_item = str(item_Array.pick_random())
		print(random_item)
		if random_item.contains("flashlight"):
			child.get_tree().add_to_group("cell_with_flashlight")
			child.remove_from_group("blank_cell")
		elif random_item.contains("night_vision_goggles"):
			child.add_to_group("cell_with_goggles")
			child.remove_from_group("blank_cell")
		elif random_item.contains("ak"):
			child.add_to_group("AK")
			child.remove_from_group("blank_cell")
		return random_item
		#return str(item_array.pick_random())
		

func set_minimums() -> void:
	minimum_Ak -= 1
	if minimum_Ak + minimum_flashlight + minimum_night_vision_goggles > get_tree().get_nodes_in_group("blank_cell").size():
		minimum_night_vision_goggles -= 1
	if minimum_Ak + minimum_flashlight + minimum_night_vision_goggles > get_tree().get_nodes_in_group("blank_cell").size():
		minimum_flashlight -= 1
	if minimum_Ak < 0:
		minimum_Ak = 0
	if minimum_night_vision_goggles < 0:
		minimum_night_vision_goggles = 0
	if minimum_flashlight < 0:
		minimum_flashlight = 0
