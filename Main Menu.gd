extends Control

@onready var main_menu_music = $Main_Menu_Music
# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	main_menu_music.get_playback_position()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func _on_play_button_pressed():
	main_menu_music.stop()
	get_tree().change_scene_to_file("res://Level_gen/Level_Generator.tscn")


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Menu_Scenes/Gameplay Controls.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Menu_Scenes/credits_screen.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
