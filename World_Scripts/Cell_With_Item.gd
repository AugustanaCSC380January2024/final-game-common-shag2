extends MeshInstance3D

#Export Variables

#OnReady Variables

@onready var night_vision_goggles = $Wooden_Box/Night_Vision_Goggles
@onready var healthkit_scene = $Wooden_Box/healthkit_scene



#Local Variables



# Called when the node enters the scene tree for the first time.
func _ready():
	#night_vision_goggles.visible = false
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Grab_Item"): # && player is colliding on cell && cell has item
		print("Item Grabbed")
		#cell.has_item = false
		#cell.item = ""


