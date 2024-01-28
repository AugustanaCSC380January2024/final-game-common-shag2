extends Node3D


@onready var line_of_sight = $Line_Of_Sight
@onready var bullet_coords = $RootNode/AKM_scene/Bullet_Coords


# Called when the node enters the scene tree for the first time.
func _ready():
	#idle.play("mixamo_com")
	#idle.is_playing()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_line_of_sight_body_entered(body):
	if body.is_in_group("player"):
		print("I See You")
