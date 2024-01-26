extends Node3D


@export var grunt_to_heavy_ratio: int







var terrain_array : Array = ["watchtower_cell", "bush_cell", "item_box_cell", "dumb_grunt_cell", "heavy_soldier_cell", "twig_cell"]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()



