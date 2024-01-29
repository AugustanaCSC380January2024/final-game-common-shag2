extends Node3D

@onready var grid_map = $NavRegion_Pathfinding/Ground/GridMap
@onready var ground = $NavRegion_Pathfinding/Ground
@onready var player1 = $Player
@onready var nav_region_pathfinding = $NavRegion_Pathfinding



@export var watchtower : PackedScene
@export var tree_cell : PackedScene
@export var grass : PackedScene
@export var bush : PackedScene
@export var twig : PackedScene
@export var dumb_grunt : PackedScene
@export var heavy_soldier : PackedScene
@export var empty_cell : PackedScene
@export var gas_can: PackedScene
@export var health_kit: PackedScene

#var is_paused : bool = false
#@onready var watch_tower = $Scene_Manager/WatchTower
#@onready var level_gen_twigs = $Scene_Manager/LevelGenTwigs
#@onready var heavy_soldier = $Scene_Manager/Heavy_Soldier
#@onready var dumb_grunt = $Scene_Manager/Dumb_Grunt
#@onready var level_gen_bush = $Scene_Manager/Level_Gen_Bush
#@onready var level_gen_grass = $Scene_Manager/Level_Gen_Grass
#@onready var level_gen_empty_cell = $Scene_Manager/Level_Gen_Empty_Cell
#@onready var gas_can_cell_scene = $Scene_Manager/Gas_Can_Cell_Scene
#@onready var level_gen_health_box = $Scene_Manager/Level_Gen_Health_Box

#var cell_array : Array[Node3D] = [watch_tower, level_gen_grass, level_gen_bush, level_gen_twigs, dumb_grunt, heavy_soldier, level_gen_empty_cell, level_gen_health_box, gas_can_cell_scene]
#var cell_array : Array[Node3D] = [watchtower, grass, bush, twig, dumb_grunt, heavy_soldier, empty_cell, health_kit, gas_can]
var number_array : Array[int] = [0,1,2,3,4,5,6,7,8,9]
# Called when the node enters the scene tree for the first time.
# set_cell_item(position: Vector3i, item: int, orientation: int = 0)


func _ready():
	create_map()
	#nav_region_pathfinding.bake_navigation_mesh(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	#Pause Menu
#	if Input.is_action_just_pressed("Pause"):
#		pauseMenu()

func create_map() -> void:

	var cell_size: Vector3i = ground.size
	var num_rows = cell_size.z / 10
	var num_cols = cell_size.x / 10
	print(num_rows)
	print(num_cols)
	var cell_z_coord = cell_size.z / 2 *-1
	cell_z_coord += 5
	print(cell_z_coord)
	var cell_x_coord = cell_size.x / 2 *-1
	cell_x_coord += 5
	print(cell_x_coord)
	
	var neg_z_bound = cell_size.z / 2 *-1
	var pos_z_bound = cell_size.z / 2
	var neg_x_bound = cell_size.x / 2 *-1
	var pos_x_bound = cell_size.x / 2
	var temp_z_coord = cell_z_coord
	var temp_x_coord = cell_x_coord
	
	for row in num_rows:
		if row != 0:
			temp_z_coord = cell_z_coord + (row*10)
		for col in num_cols:
			if col == 0:
				temp_x_coord = cell_x_coord
			else:
				temp_x_coord = cell_x_coord + (col*10)
			var child: Node3D = pick_cell(temp_z_coord, temp_x_coord)
			child.global_position = Vector3i(temp_x_coord,0,temp_z_coord)
			print(Vector3i(temp_x_coord,0,temp_z_coord))
			grid_map.set_cell_item(Vector3i(temp_x_coord,0,temp_z_coord), 5)
			
			
	
	
	
func pick_cell(z_coord: int, x_coord: int) -> Node3D:
	if z_coord < 50 and z_coord > -50 and x_coord < 50 and x_coord > -50:
		var child = empty_cell.instantiate()
		add_child(child)
		return child
	else:
		var picked = number_array.pick_random()
		if picked == 0:
			var child = bush.instantiate()
			add_child(child)
			return child
		elif picked == 1:
			var child = tree_cell.instantiate()
			add_child(child)
			return child
		elif picked == 2:
			var child = twig.instantiate()
			add_child(child)
			return child
		elif picked == 3:
			var child = dumb_grunt.instantiate()
			add_child(child)
			var empty: Node3D = empty_cell.instantiate()
			add_child(empty)
			empty.global_position = Vector3i(x_coord, 0, z_coord)
			return child
		elif picked == 4:
			var child = heavy_soldier.instantiate()
			add_child(child)
			var empty: Node3D = empty_cell.instantiate()
			add_child(empty)
			empty.global_position = Vector3i(x_coord, 0, z_coord)
			return child
		elif picked == 5:
			var child = empty_cell.instantiate()
			add_child(child)
			return child
		elif picked == 6:
			var child = gas_can.instantiate()
			child.player = player1
			add_child(child)
			return child
		elif picked == 7:
			var child = health_kit.instantiate()
			add_child(child)
			return child
		elif picked == 8:
			var child = watchtower.instantiate()
			add_child(child)
			var empty: Node3D = empty_cell.instantiate()
			add_child(empty)
			empty.global_position = Vector3i(x_coord, 0, z_coord)
			return child
		elif picked == 9:
			var child = grass.instantiate()
			add_child(child)
			return child
		else:
			var child = empty_cell.instantiate()
			add_child(child)
			return child

func get_cell_id(cell_Node : Node3D) -> int:
	for group in cell_Node.get_groups():
		if group == "watchtower":
			return 8
		elif group == "bush":
			return 0
		elif group == "dumb_grunt" :
			return 3
		elif group == "twig":
			return 2
		elif group == "gas_can":
			return 6
		elif group == "heavy_soldier":
			return 4
		elif group == "tree":
			return 1
		elif group == "health_kit":
			return 7
		elif group == "empty":
			return 5
		
		
	return 0
#func pauseMenu():
#	if is_paused:
#		pause_menu.hide()
#		Engine.time_scale = 1
#	else:
#		pause_menu.show()
#		Engine.time_scale = 0
#	is_paused = !is_paused
