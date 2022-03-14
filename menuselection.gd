extends Area2D

var velocity = Vector2()

func _ready():
	pass
	
func _process(delta):
	velocity.x = 850
	translate(velocity*delta)