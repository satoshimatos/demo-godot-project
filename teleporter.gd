extends RigidBody2D

var hero
var tp_out = false
var modulator = 0
var change_scene = true
var changing_scene = true
var global

export var scene = "res://stageONE.tscn"
export var anim = "hat"

func _ready():
	hero = get_tree().get_nodes_in_group("heroes")[0]
	global = $"/root/Global"

func _process(delta):
	
	if tp_out:
		
		$teleport_out.value -= delta*100
		modulator += 0.1
		$teleport_out.modulate = Color(modulator, modulator, modulator, 1)
		if changing_scene and $teleport_out.value <= 50:
			changing_scene = false
			$teleport_out/teleport_out_particles.emitting = false
			$blackscreen/anim.play("fadeout")
			global.get_node("StageZERO/audio_controller").play("fadeout")
			yield($blackscreen/anim, "animation_finished")
			var _unused = get_tree().change_scene(scene)

	if change_scene and hero.global_position.x >= global_position.x and hero.global_position.x <= global_position.x + 5:
		change_scene = false
		global.get_node("Pause").pause_enabled = false
		global.get_node("timer").paused = true
		hero.idle = true
		hero.start = false
		hero.controls = false
		hero.velocity.x = 0
		hero.velocity.y = 300
		hero.get_node("animation").flip_h = false
		for enemy in get_tree().get_nodes_in_group("enemies"):
			enemy.hp = 0
		hero.get_node("animation").play(anim)
		$ping_timer.start()
		yield($ping_timer,"timeout")
		$ping.play()
		yield(hero.get_node("animation"), "animation_finished")
		hero.visible = false
		$teleport_out.visible = true
		$teleport_out/teleport_out_particles.emitting = true
		tp_out = true
		$tp_out.play()