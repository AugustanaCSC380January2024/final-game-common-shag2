extends Label


# Called when the node enters the scene tree for the first time.
var ammo = 30
var set_ammo: int:
	set(ammo_in):
		ammo = ammo_in

func _ready():
	text = "Ammo: " + str(ammo)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
