extends Node2D

func _ready():
	pass

func _process(_delta):
	if $progress.value == 15:
		$progress.modulate = Color(0, .5, 0, 1)
	elif $progress.value == 14:
		$progress.modulate = Color(.1, .5, 0, 1)
	elif $progress.value == 13:
		$progress.modulate = Color(.2, .5, 0, 1)
	elif $progress.value == 12:
		$progress.modulate = Color(.3, .5, 0, 1)
	elif $progress.value == 11:
		$progress.modulate = Color(.4, .5, 0, 1)
	elif $progress.value == 10:
		$progress.modulate = Color(.5, .5, 0, 1)
	elif $progress.value == 9:
		$progress.modulate = Color(.6, .5, 0, 1)
	elif $progress.value == 8:
		$progress.modulate = Color(.7, .5, 0, 1)
	elif $progress.value == 7:
		$progress.modulate = Color(.8, .5, 0, 1)
	elif $progress.value == 6:
		$progress.modulate = Color(.9, .5, 0, 1)
	elif $progress.value == 5:
		$progress.modulate = Color(1, .4, 0, 1)
	elif $progress.value == 4:
		$progress.modulate = Color(1, .3, 0, 1)
	elif $progress.value == 3:
		$progress.modulate = Color(1, .2, 0, 1)
	elif $progress.value == 2:
		$progress.modulate = Color(1, .1, 0, 1)
	elif $progress.value == 1:
		$progress.modulate = Color(1, 0, 0, 1)

