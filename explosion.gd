extends AnimatedSprite

var x = 1
var dying = false


func _ready():
	play("explosion")
	$particles.emitting = true
	pass

func _process(delta):
	if $light.energy >= 0 and $light.energy < 1 and !dying:
		$light.energy += delta
	elif $light.energy >= 0.1:
		dying = true
		x -= delta*2
		$particles.emitting = false
		$light.energy -= delta*2
	else:
		queue_free()



