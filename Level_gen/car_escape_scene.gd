extends Node3D

@onready var interactable = $Interactable

@export var num_gas_cans_to_win : int

var filled_cans = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("deposit_gas_can", fill_car)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if filled_cans == num_gas_cans_to_win:
		print("You Escaped Russia")
		SignalManager.emit_signal("win_game")


func _on_interactable_body_entered(body):
	pass # Replace with function body.

func fill_car():
	filled_cans += 1
