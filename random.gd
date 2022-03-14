extends Node2D

var x

func _process(delta):
	randomize()
	x = (randi() % 10+1)
	print(x)
	
	match x:
		0:
			print("ok zero")
		1:
			print("ok one")
		2:
			print("ok two")
		_:
			print("ok any number")