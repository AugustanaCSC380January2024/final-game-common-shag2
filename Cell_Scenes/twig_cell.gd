extends MeshInstance3D

signal twig_snap

@onready var twig_snap_audio = $Twig_Snap_Audio

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		twig_snap_audio.play()
		SignalManager.twig_detection_timer.emit()
		SignalManager.twig_player_position.emit(body.global_position)

	
	
