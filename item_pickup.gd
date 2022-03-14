extends Particles2D

var value

func _ready():
	self.emitting = true
	$light/anim.play("fadeout")
	$Timer.start()

func _process(_delta):
	value = $light/shield.get_value()
	$light/shield.set_value(value-2)

func _on_Timer_timeout():
	queue_free()