extends Control

@export var offset: float = 1

func _physics_process(delta):
	var new_pos = position + (get_global_mouse_position()/offset*delta) - position
	
	position = position.lerp(new_pos, delta * 3.0)
