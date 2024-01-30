extends Node3D
#small error when removing child
#other than that certified working script

@export var speed := 30.0
@export var damage:= 18

@onready var bullet_area = $bullet_area

var direction:= Vector3.FORWARD

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _ready():
	set_physics_process(true)

func _on_timer_timeout():
	queue_free()
	remove_child(self)

func _on_bullet_area_area_entered(area):
	if area.is_in_group("enemy_area"):
		area.get_parent().current_health -= damage
		queue_free()
		#emove_child(self)
	if area.is_in_group("enemy_hitbox"):
		
	#	area.get_parent().current_health -= damage
		queue_free()
		remove_child(self)
	


func _on_bullet_area_body_entered(body):
	if body.is_in_group("Heavy_Soldier_Body"):
		body.get_parent().current_health -= damage
		queue_free()
		remove_child(self)
	#if body.is_in_group("player"):
	#	body.current_health -= damage
	#	queue_free()
	#	remove_child(self)
