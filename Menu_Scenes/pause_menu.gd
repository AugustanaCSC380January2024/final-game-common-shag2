extends Control

@onready var resume_button = $"MarginContainer/VBoxContainer/Resume Button"
@onready var gameplay_controls_button = $"MarginContainer/VBoxContainer/Gameplay Controls Button" 
@onready var quit_to_main_button = $"MarginContainer/VBoxContainer/Quit to Main Button"
@onready var quit_game_button = $"MarginContainer/VBoxContainer/Quit Game Button"
# Called when the node enters the scene tree for the first time.
func _ready():
	resume_button.toggled = true
	gameplay_controls_button.toggled = false
	quit_to_main_button.toggled = false
	quit_game_button.toggled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Button_Toggle_Up"):
		pass


func _on_resume_button_pressed():
	pass # Replace with function body.


func _on_gameplay_controls_button_pressed():
	pass # Replace with function body.


func _on_quit_to_main_button_pressed():
	get_tree().change_scene_to_file("res://Menu_Scenes/main_menu_screen.tscn")


func _on_quit_game_button_pressed():
	get_tree().quit()

func what_is_toggled():
	pass

func _on_resume_button_toggled(toggled_on):
	pass # Replace with function body.


func _on_gameplay_controls_button_toggled(toggled_on):
	pass # Replace with function body.


func _on_quit_to_main_button_toggled(toggled_on):
	pass # Replace with function body.


func _on_quit_game_button_toggled(toggled_on):
	pass # Replace with function body.
