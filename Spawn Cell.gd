extends Node3D

@onready var easy_spawn_timer = $"Easy Spawn Timer"
@onready var medium_spawn_timer = $"Medium Spawn Timer"
@onready var hard_spawn_timer = $"Hard Spawn Timer"

@export var heavy_soldier : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	set_correct_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func set_correct_timer():
	if SignalManager.difficulty == 1:
		easy_spawn_timer.start()
	elif SignalManager.difficulty == 2:
		medium_spawn_timer.start()
	elif SignalManager.difficulty == 3:
		hard_spawn_timer.start()
	else:
		easy_spawn_timer.start()


func _on_easy_spawn_timer_timeout():
	pass


func _on_medium_spawn_timer_timeout():
	pass # Replace with function body.


func _on_hard_spawn_timer_timeout():
	pass # Replace with function body.
