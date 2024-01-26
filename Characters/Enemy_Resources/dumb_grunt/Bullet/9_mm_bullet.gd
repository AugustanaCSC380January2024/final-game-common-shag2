extends Node3D
#small error when removing child
#other than that certified working script

@export var speed := 15.0
@export var damage:= 13

@onready var bullet_area = $Bullet_Area

var direction:= Vector3.FORWARD

func _physics_process(delta: float) -> void:
	position -= direction * speed * delta

func _ready():
	set_physics_process(true)

func _on_timer_timeout():
	queue_free()
	remove_child(self)


func _on_bullet_area_area_entered(area):
	if area.is_in_group("player_collidor"):
		area.get_parent().current_health -= damage
		queue_free()
		remove_child(self)
