extends Camera2D

func _ready():
	print(custom_viewport)
	custom_viewport = get_node("../Viewport")
	print(custom_viewport)