extends Sprite

var mouse

func _ready():
	pass
	
func _process(_delta):
	look_at(get_global_mouse_position())
	if rotation_degrees < 315 and rotation_degrees > 45:
		print("ok")
	else:
		print("not ok")