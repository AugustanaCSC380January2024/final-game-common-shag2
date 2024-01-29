extends Control

@onready var resume_button = $"MarginContainer/VBoxContainer/Resume Button"
@onready var gameplay_controls_button = $"MarginContainer/VBoxContainer/Gameplay Controls Button" 
@onready var quit_to_main_button = $"MarginContainer/VBoxContainer/Quit to Main Button"
@onready var quit_game_button = $"MarginContainer/VBoxContainer/Quit Game Button"
@onready var error_sound_effect = $Error_Sound_Effect
@onready var toggle_1 = $MarginContainer2/VBoxContainer/toggle_1
@onready var toggle_2 = $MarginContainer2/VBoxContainer/toggle_2
@onready var toggle_3 = $MarginContainer2/VBoxContainer/toggle_3
@onready var toggle_4 = $MarginContainer2/VBoxContainer/toggle_4

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
	pass
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


func _on_resume_button_pressed():
	pass # Replace with function body.


func _on_gameplay_controls_button_pressed():
	pass # Replace with function body.


func _on_quit_to_main_button_pressed():
	get_tree().change_scene_to_file("res://Menu_Scenes/main_menu_screen.tscn")

func on_quit_to_main_action():
	get_tree().change_scene_to_file("res://Menu_Scenes/main_menu_screen.tscn")

func on_quit_game_button_action():
	get_tree().quit()
	
	
func on_resume_button_action():
	print("Unpause...")
	
func on_gameplay_controls_action():
	print("Gameplay")

func _on_quit_game_button_pressed():
	get_tree().quit()



func _on_resume_button_toggled(toggled_on):
	pass # Replace with function body.


func _on_gameplay_controls_button_toggled(toggled_on):
	pass # Replace with function body.


func _on_quit_to_main_button_toggled(toggled_on):
	pass # Replace with function body.


func _on_quit_game_button_toggled(toggled_on):
	pass # Replace with function body.
