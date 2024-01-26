extends GridMap


@onready var floor = $"."


@onready var player = $"../../Player"

var terrain_array : Array = ["watchtower_cell", "bush_cell", "item_box_cell", "dumb_grunt_cell", "heavy_soldier_cell", "twig_cell"]


# Called when the node enters the scene tree for the first time.
func _ready():
	#for cell in get_tree().get_nodes_in_group("blank_cell"):
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

