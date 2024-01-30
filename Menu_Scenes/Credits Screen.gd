extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Menu_Scenes/main_menu.tscn")


func _on_play_credits_button_pressed():
	get_tree().change_scene_to_file("res://Credits Scene Package/CREDITS/GodotCredits.tscn")
