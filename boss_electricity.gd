extends Light2D

var lightning: float

func _ready():
	pass

func _process(_delta):
	lightning = randi() % 11
	energy = 1.5 + (lightning/10)