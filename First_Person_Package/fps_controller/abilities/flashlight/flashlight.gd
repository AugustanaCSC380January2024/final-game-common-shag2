extends SpotLight3D

var can_use = true

func _ready():
	hide()

func _input(event):
	if Input.is_action_pressed("Flashlight_Toggle"):
		if can_use:
			visible = !visible
			$FlashlightToggleSound.pitch_scale = randf_range(0.95, 1.05)
			$FlashlightToggleSound.play()
			can_use = false
	else:
		can_use = true
