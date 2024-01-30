extends Control

@onready var victory_sfx = $"Victory sfx"

# Called when the node enters the scene tree for the first time.
func _ready():
	victory_sfx.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://Level_gen/Level_Generator.tscn")


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Menu_Scenes/main_menu.tscn")


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Level_gen/GodotCredits.tscn")
