extends Control

@onready var womp_womp = $"Womp Womp"

# Called when the node enters the scene tree for the first time.
func _ready():
	womp_womp.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://Level_gen/Level_Generator.tscn")


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Menu_Scenes/main_menu.tscn")


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Level_gen/GodotCredits.tscn")
