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

@export var spawn_cell : PackedScene
@export var animated_soldier : PackedScene




var x_bound : int
var z_bound : int
var number_array : Array[int] = [0,1,2,3,5,6,7,8,9]
# Called when the node enters the scene tree for the first time.
# set_cell_item(position: Vector3i, item: int, orientation: int = 0)
var safe_array : Array[int] = [0,2,5,6,7,9]

var probability : Array[int] = [1,2,3,4,5,6,7,8,9,10]

var mode_id : int

var num_spawn_cells : int
var current_spawn_cells : int = 0

func _ready():
	SignalManager.difficulty_mode.connect(set_mode_id)

	#create_map()
	create_updated_map(mode_id)
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

func create_updated_map(Mode : int) -> void:

	var cell_size: Vector3i = ground.size
	var num_rows = cell_size.z / 10
	var num_cols = cell_size.x / 10
	var cell_z_coord = cell_size.z / 2 *-1
	cell_z_coord += 5
	var cell_x_coord = cell_size.x / 2 *-1
	cell_x_coord += 5
	

	z_bound = cell_size.z / 2
	x_bound = cell_size.x / 2
	
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
			pick_updated_cell(temp_z_coord, temp_x_coord)
			#child.global_position = Vector3i(temp_x_coord,0,temp_z_coord)
			#print(Vector3i(temp_x_coord,0,temp_z_coord))
			#grid_map.set_cell_item(Vector3i(temp_x_coord,0,temp_z_coord), 5)






func pick_updated_cell(x_coord: int, z_coord: int):
#	print("X coord " + str(x_coord))
#	print("Z coord " + str(z_coord))
	if z_coord < 15 and z_coord > -15 and x_coord < 15 and x_coord > -15:
		var child = empty_cell.instantiate()
		add_child(child)
		child.global_position = Vector3i(x_coord, 0, z_coord)
	elif z_coord < 50 and z_coord > -50 and x_coord < 50 and x_coord > -50:
		var picked = safe_array.pick_random()
		set_cell(picked, z_coord, x_coord)

			
	elif current_spawn_cells < num_spawn_cells and ((z_coord > z_bound-20 and x_coord > x_bound - 20) or (z_coord < (z_bound *-1) + 20 and x_coord > x_bound -20) or (z_coord > z_bound -20 and x_bound < (x_bound *-1) + 20) or (z_coord < (z_bound *-1) +20) and x_coord < (x_coord * -1) +20):
		var choose = probability.pick_random()
		if choose == 1:
			var child = spawn_cell.instantiate()
			add_child(child)
			child.global_position = Vector3i(x_coord,0,z_coord)
			current_spawn_cells += 1
			print("Spawned Spawn Cell")
		else:
			var picked = number_array.pick_random()
			set_cell(picked, x_coord, z_coord)
	elif current_spawn_cells == 0 and (z_coord > z_bound - 10 and x_coord > x_bound - 10):
		var child = spawn_cell.instantiate()
		add_child(child)
		child.global_position = Vector3i(x_coord,0,z_coord)
		current_spawn_cells += 1
		print("Force Spawned Spawn Cell")
	else:
		var picked = number_array.pick_random()
		set_cell(picked, x_coord, z_coord)
		

func set_cell(picked : int, z_coord: int, x_coord: int):
	if picked == 0:
		var child = bush.instantiate()
		add_child(child)
		child.global_position = Vector3i(x_coord,0,z_coord)
	elif picked == 1:
		var child = tree_cell.instantiate()
		add_child(child)
		child.global_position = Vector3i(x_coord,0,z_coord)
	elif picked == 2:
		var child = twig.instantiate()
		add_child(child)
		child.global_position = Vector3i(x_coord,0,z_coord)
	elif picked == 3:
		var child = dumb_grunt.instantiate()
		add_child(child)
		child.global_position = Vector3i(x_coord,0,z_coord)
		var empty: Node3D = empty_cell.instantiate()
		add_child(empty)
		empty.global_position = Vector3i(x_coord, 0, z_coord)
	elif picked == 5:
		var child = empty_cell.instantiate()
		add_child(child)
		child.global_position = Vector3i(x_coord,0,z_coord)
	elif picked == 6:
		var child = gas_can.instantiate()
		child.player = player1
		add_child(child)
		child.global_position = Vector3i(x_coord,0,z_coord)
	elif picked == 7:
		var child = health_kit.instantiate()
		add_child(child)
		child.global_position = Vector3i(x_coord,0,z_coord)
	elif picked == 8:
		var child = watchtower.instantiate()
		add_child(child)
		child.global_position = Vector3i(x_coord,0,z_coord)
		return child
	elif picked == 9:
		var child = grass.instantiate()
		add_child(child)
		child.global_position = Vector3i(x_coord,0,z_coord)
	else:
		var child = empty_cell.instantiate()
		add_child(child)
		child.global_position = Vector3i(x_coord,0,z_coord)


func set_mode_id(difficulty : int):
	mode_id = difficulty
	set_spawn_cells(mode_id)

func set_spawn_cells(difficulty : int):
	if difficulty == 1:
		num_spawn_cells = 3
	elif difficulty == 2:
		num_spawn_cells = 4
	elif num_spawn_cells == 3:
		num_spawn_cells = 5
	else:
		num_spawn_cells = 3
