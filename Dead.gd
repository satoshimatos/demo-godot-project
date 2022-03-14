extends AnimatedSprite

func _ready():
	randomize()
	$explosion.pitch_scale = (randi() % 15)/10.0 +.5
	play("plop")
	playing = true
	$light/anim.play("light")

func _on_plop_animation_finished():
	queue_free()