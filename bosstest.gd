extends Node2D

var hero
var start = preload ("res://teleport_in.tscn")
var hp
var global
var spawn = preload ("res://boss.tscn")


func _ready():
	
	global = get_node("/root/Global")
	global.get_node("StageONE/audio_controller").play("fadeout")
	add_to_group("boss_room")
	hp = get_tree().get_nodes_in_group("hp")[0]
	var go = start.instance()
	add_child(go)
	hero = get_tree().get_nodes_in_group("heroes")[0]
	hero.z_index = 1
	go.global_position = hero.global_position
	hero.start = false
	hero.controls = false

func _on_timertostart_timeout():
	var boss = spawn.instance()
	add_child(boss)
	boss.global_position = Vector2(280, -200)
	$hud/whitescreen/anim.play("flashing")