extends Control

@onready var resume_button = $"Button_Container/VBoxContainer/Resume Button"
@onready var gameplay_controls_button = $"Button_Container/VBoxContainer/Gameplay Controls Button" 
@onready var quit_to_main_button = $"Button_Container/VBoxContainer/Quit to Main Button"
@onready var quit_game_button = $"Button_Container/VBoxContainer/Quit Game Button"
@onready var error_sound_effect = $Error_Sound_Effect
@onready var toggle_1 = $"Arrow Container/VBoxContainer/toggle_1"
@onready var toggle_2 = $"Arrow Container/VBoxContainer/toggle_2"
@onready var toggle_3 = $"Arrow Container/VBoxContainer/toggle_3"
@onready var toggle_4 = $"Arrow Container/VBoxContainer/toggle_4"

@onready var game_play_pause = $"GamePlay Pause"
@onready var button_container = $Button_Container
@onready var arrow_container = $"Arrow Container"

@onready var main = $"../../../"
var on_gameplay_menu : bool = false
var button_toggled : int
# Called when the node enters the scene tree for the first time.
func _ready():
	toggle_2.visible = false
	toggle_3.visible = false
	toggle_4.visible = false
	#resume_button._toggled = true
	#gameplay_controls_button._toggled = false
	#quit_to_main_button._toggled = false
	#quit_game_button._toggled = false
	button_toggled = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not on_gameplay_menu:
		if Input.is_action_just_pressed("Button_Toggle_Up"):
			if button_toggled <= 1:
				if error_sound_effect.playing == false:
					error_sound_effect.play()
			elif button_toggled == 2:
				toggle_1.visible = true
				toggle_2.visible = false
				button_toggled = 1
			elif button_toggled == 3:
				toggle_2.visible = true
				toggle_3.visible = false
				button_toggled = 2
			elif button_toggled == 4:
				toggle_3.visible = true
				toggle_4.visible = false
				button_toggled = 3
		
		if Input.is_action_just_pressed("Button_Toggle_Down"):
			if button_toggled >= 4:
				if error_sound_effect.playing == false:
					error_sound_effect.play()
			elif button_toggled == 3:
				toggle_4.visible = true
				toggle_3.visible = false
				button_toggled = 4
			elif button_toggled == 2:
				toggle_3.visible = true
				toggle_2.visible = false
				button_toggled = 3
			elif button_toggled == 1:
				toggle_2.visible = true
				toggle_1.visible = false
				button_toggled = 2
				
		if Input.is_action_just_pressed("Button_Action_On_Toggle"):
			if button_toggled < 1:
				button_toggled = 1
			if button_toggled > 4:
				button_toggled = 4
			if button_toggled == 1:
				on_resume_button_action()
			elif button_toggled == 2:
				on_gameplay_controls_action()
			elif button_toggled == 3:
				on_quit_to_main_action()
			elif button_toggled == 4:
				on_quit_game_button_action()
	else:
		if Input.is_action_just_pressed("Button_Action_On_Toggle"):
			game_play_pause.hide()
			on_gameplay_menu = false
			arrow_container.show()
			button_container.show()


func _on_resume_button_pressed():
	pass # Replace with function body.


func _on_gameplay_controls_button_pressed():
	pass # Replace with function body.


func _on_quit_to_main_button_pressed():
	get_tree().change_scene_to_file("res://Menu_Scenes/main_menu.tscn")

func on_quit_to_main_action():
	get_tree().change_scene_to_file("res://Menu_Scenes/main_menu.tscn")

func on_quit_game_button_action():
	get_tree().quit()
	
	
func on_resume_button_action():
	print("Sending Unpause")
	main.pauseMenu()
	
func on_gameplay_controls_action():
	on_gameplay_menu = true
	game_play_pause.show()
	arrow_container.hide()
	button_container.hide()

func _on_quit_game_button_pressed():
	get_tree().quit()



