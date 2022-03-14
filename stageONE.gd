extends Node2D

var hero
var start = preload ("res://teleport_in.tscn")
var hp
var global

func _ready():
	global = get_node("/root/Global")
	global.get_node("StageONE").play()
	global.get_node("StageONE/audio_controller").play("start")
	global.set_stage(1)
	global.set_timer(1)
	global.hero_hp = 100
	add_to_group("boss_room")
	hp = get_tree().get_nodes_in_group("hp")[0]
	var go = start.instance()
	add_child(go)
	hero = get_tree().get_nodes_in_group("heroes")[0]
	go.global_position = hero.global_position
	
func _process(_delta):
	pass