extends Node3D

@onready var idle_dying = $Idle_Dying
@onready var reload_moving_forwards = $Reload_Moving_Forwards
@onready var hit_reaction_idle = $Hit_Reaction_Idle
@onready var turn_right_45_moving = $Turn_Right_45_Moving
@onready var aiming_to_down = $Aiming_To_Down
@onready var turn_right_90_not_aimed = $Turn_Right_90_Not_Aimed
@onready var walking_hit_reaction = $Walking_Hit_Reaction
@onready var down_to_aim = $Down_To_Aim
@onready var start_walking_aimed = $Start_Walking_Aimed
@onready var turn_left_45 = $Turn_Left_45
@onready var turn_left_90 = $Turn_Left_90
@onready var idle = $Idle

@onready var line_of_sight = $Line_Of_Sight
@onready var bullet_coords = $RootNode/AKM_scene/Bullet_Coords


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_line_of_sight_body_entered(body):
	if body.is_in_group("player"):
		print("I See You")
