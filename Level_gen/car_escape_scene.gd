extends Node3D

@export var num_gas_cans_to_win : int

@onready var interactable = $Interactable
@onready var end_game_timer = $"End Game Timer"
@onready var car_sound = $"Car Sound"

var filled_cans = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("deposit_gas_can", fill_car)
	set_cans_to_win()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if filled_cans == num_gas_cans_to_win:
		SignalManager.win_game.emit()
		end_game_timer.start()
		car_sound.play()
		end_game_timer.start()


func _on_interactable_body_entered(body):
	pass # Replace with function body.

func fill_car():
	filled_cans += 1

func _on_end_game_timer_timeout():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Menu_Scenes/victory_screen.tscn")

func set_cans_to_win():
	if SignalManager.difficulty == 1:
		num_gas_cans_to_win == 5;
	elif SignalManager.difficulty == 2:
		num_gas_cans_to_win == 8
	elif SignalManager.difficulty == 3:
		num_gas_cans_to_win == 12
