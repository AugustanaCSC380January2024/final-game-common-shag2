extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Level_gen/Level_Generator.tscn")


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Menu_Scenes/main_menu.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Levels/credits_screen.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
