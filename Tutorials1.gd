extends Label

var canstart = true
var start

func _process(delta):
	if start:
		$lighting.energy = 1
		percent_visible += delta*0.4
		if percent_visible > 0.9 and canstart:
			canstart = false
			$Timer.start()
	else:
		$lighting.energy = 0
		percent_visible = 0

func _on_Timer_timeout():
	percent_visible = 0
	canstart = true