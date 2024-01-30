extends Node3D

@export var speed := 30.0
@export var damage:= 14

@onready var enemy_bullet_area = $Enemy_Bullet_Area

var direction:= Vector3.FORWARD
@onready var despawn_timer = $Despawn_Timer

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _ready():
	set_physics_process(true)
	despawn_timer.start()
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_despawn_timer_timeout():
		queue_free()
		remove_child(self)


func _on_enemy_bullet_area_area_entered(area):
	if area.is_in_group("player_collidor"):
		area.get_parent().current_health -= damage
		queue_free()
		remove_child(self)
