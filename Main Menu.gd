extends Control
@onready var mode_containors = $"Mode Containors"
@onready var main_menu_music = $Main_Menu_Music
@onready var play_button = $"Menu Container/Play Button"
@onready var options_button = $"Menu Container/Options Button"
@onready var credits_button = $"Menu Container/Credits Button"
@onready var quit_button = $"Menu Container/Quit Button"
@onready var easy_mode_button = $"Mode Containors/Mode Container/Easy Mode Button"
@onready var hard_mode_button = $"Mode Containors/Mode Container/Hard Mode Button"
@onready var back_to_main = $"Mode Containors/Back To Main"



@onready var menu_container = $"Menu Container"
# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	main_menu_music.get_playback_position()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()


func _on_play_button_pressed():
	mode_containors.visible = true
	menu_container.visible = false
	play_button.disabled = true
	options_button.disabled = true
	credits_button.disabled = true
	quit_button.disabled = true
	easy_mode_button.disabled = false
	hard_mode_button.disabled = false
	back_to_main.disabled = false
	
func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Menu_Scenes/Gameplay Controls.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Menu_Scenes/credits_screen.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


func _on_easy_mode_button_pressed():
	SignalManager.emit_signal("easy_mode")
	get_tree().change_scene_to_file("res://Level_gen/Level_Generator.tscn")

func _on_hard_mode_button_pressed():
	SignalManager.emit_signal("hard_mode")
	get_tree().change_scene_to_file("res://Level_gen/Level_Generator.tscn")


func _on_back_to_main_pressed():
	mode_containors.visible = false
	menu_container.visible = true
	play_button.disabled = false
	options_button.disabled = false
	credits_button.disabled = false
	quit_button.disabled = false
	easy_mode_button.disabled = true
	hard_mode_button.disabled = true
	back_to_main.disabled = true
