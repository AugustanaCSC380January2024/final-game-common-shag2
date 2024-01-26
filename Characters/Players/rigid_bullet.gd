extends RigidBody3D

var direction:= Vector3.FORWARD
@onready var bullet_area = $bullet_area

@export var speed := 10.0
@export var damage:= 18

func _physics_process(delta: float) -> void:
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta
	print(position)




func _on_timer_timeout():
	print("Timed Out")
	remove_child(self)
	queue_free() # Replace with function body
