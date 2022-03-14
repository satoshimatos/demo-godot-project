extends Node2D

var hero
var tp_out = false
var modulator = 0
var change_scene = true
var changing_scene = true
var global
var play_once = true

export var scene = "res://MainMenu.tscn"
export var anim = "hat"

func _ready():
	hero = get_tree().get_nodes_in_group("heroes")[0]
	global = $"/root/Global"

func _process(delta):
	hero.controls = false
	hero.start = false
	if tp_out:
		
		$teleport_out.value -= delta*100
		modulator += 0.1
		$teleport_out.modulate = Color(modulator, modulator, modulator, 1)
		if changing_scene and $teleport_out.value <= 50:
			changing_scene = false
			$teleport_out/teleport_out_particles.emitting = false
			$blackscreen/anim.play("fadeout")


	if play_once:
		play_once = false
		change_scene = false
		global.get_node("timer").paused = true
		hero.get_node("animation").flip_h = false
		$ping_timer.start()
		hero.get_node("animation").play(anim)
		yield(hero.get_node("animation"), "animation_finished")
		hero.visible = false
		$teleport_out.visible = true
		$teleport_out/teleport_out_particles.emitting = true
		tp_out = true
		$tp_out.play()
		

func _on_ping_timer_timeout():
	$ping.play()

func _on_anim_animation_finished(_anim_name):
	var _unused = get_tree().change_scene(scene)
	queue_free()