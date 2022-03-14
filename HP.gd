extends Node2D

const hp = 1

export var max_hp = 100
var hp_percent
var global

func _ready():
	global = get_node("/root/Global")

	add_to_group("hp")


func _process(_delta):
	var hero = get_tree().get_nodes_in_group("heroes")[0]
	hp_percent = max_hp*global.hero_hp/100
	$bar.set_value(hp_percent)
	$counter.set_text(str(global.hero_hp))
	if global.hero_hp >= max_hp:
		global.hero_hp = max_hp

		$bar.self_modulate = Color(0, 8, 0)
	elif global.hero_hp > 80 && global.hero_hp < 100:
		$bar.self_modulate = Color(1, 8, 0)
	elif global.hero_hp > 70 && global.hero_hp < 81:
		$bar.self_modulate = Color(1.4, 8, 0)
	elif global.hero_hp > 50 && global.hero_hp < 71:
		$bar.self_modulate = Color(1.6, 8, 0)
	elif global.hero_hp > 35 && global.hero_hp < 51:
		$bar.self_modulate = Color(1.8, 8, 0)
	elif global.hero_hp > 25 && global.hero_hp < 36:
		$bar.self_modulate = Color(2, 7, 0)
	elif global.hero_hp > 10 && global.hero_hp < 26:
		$bar.self_modulate = Color(2.1, 5, 0)
	elif global.hero_hp > 0 && global.hero_hp < 11:
		$bar.self_modulate = Color(2.2, 3, 0)
	elif global.hero_hp <= 0:
		hero.start = false
		hero.velocity.x = 0
		global.hero_hp = 0
		hero.set_collision_mask_bit(0, false)
		hero.get_node("lighting").energy = 2
		hero.get_node("animation").play("death")
		$dark/anim.play("fadeout")


func _on_enemy_armor_hit():
	if global.hero_hp <= max_hp && global.hero_hp > 0:
		$damage.play()
		global.hero_hp += -15

func _on_enemy_hit():
	if global.hero_hp <= max_hp && global.hero_hp > 0:
		$damage.play()
		global.hero_hp += -15
		
func _on_boss_bosshit():
	if global.hero_hp <= max_hp && global.hero_hp > 0:
		$damage.play()
		global.hero_hp += -15

func _on_heart_heart_collected():
	get_tree().get_nodes_in_group("heroes")[0].get_node("collect").play("collected")
	if global.hero_hp < max_hp:
		global.hero_hp += 25
	
func _near_basin():
	if global.hero_hp < max_hp and global.hero_hp > 0:
		global.hero_hp += 2
		
func go_to_menu():
	var _unused = get_tree().change_scene("res://MainMenu.tscn")

func _on_anim_animation_finished(_anim_name):
	go_to_menu()