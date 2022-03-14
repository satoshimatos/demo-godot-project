extends Area2D

const SPEED = 600
const DECELERATION = 35

var hero
var isnt_tping = true
var global

signal _go

func _ready():
	global = $"/root/Global"
	global.get_node("Pause").pause_enabled = false
	global.get_node("timer").paused = true
	hero = get_tree().get_nodes_in_group("heroes")[0]
	var _unused = connect("_go", hero, "_ready_to_start")

	 
func _process(_delta):
	if $Timer.time_left <= 0 and isnt_tping:
		$tp.value += 0.5
		if $tp.value >= 150:
			$tp/particles.emitting = false
			$animtimer.start()
			$tp/flash/anim.play("tp_in")
			isnt_tping = false
			$tp_in/wait_time.start()
			yield($tp_in/wait_time,"timeout")
			$tp_in/tp_in_finished.play()
func _on_anim_animation_finished(_anim_name):
	emit_signal("_go")
	yield($tp_in, "finished")
	global.get_node("Pause").pause_enabled = true
	queue_free()

func _on_animtimer_timeout():
	$tp.value = 0