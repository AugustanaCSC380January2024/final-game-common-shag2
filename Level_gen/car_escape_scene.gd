extends Node3D

@export var num_gas_cans_to_win : int

@onready var interactable = $Interactable
@onready var end_game_timer = $"End Game Timer"
@onready var car_sound = $"Car Sound"

var filled_cans = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("deposit_gas_can", fill_car)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if filled_cans == num_gas_cans_to_win:
		end_game_timer.start()
		car_sound.play()
		SignalManager.emit_signal("win_game")


func _on_interactable_body_entered(body):
	pass # Replace with function body.

func fill_car():
	filled_cans += 1

func _on_end_game_timer_timeout():
	pass # Replace with function body.
