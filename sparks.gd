extends Particles2D

func _ready():

	$anim.play("fadeout")
	$anim2.play("fadeout")
	$Timer.start()

func _on_Timer_timeout():
	queue_free()