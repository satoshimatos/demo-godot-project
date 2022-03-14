extends Area2D

signal near_basin
var canheal = true
var hero
var pickup = preload ("res://hptextbasin.tscn")
var hp
var global

export var range_x = 80
export var range_y = 80

func _ready():
	global = get_node("/root/Global")
	hero = get_tree().get_nodes_in_group("heroes")[0]
	var _unused = self.connect("near_basin", get_tree().get_nodes_in_group("hp")[0], "_near_basin")
	hp = get_tree().get_nodes_in_group("hp")[0]
	$coal/anim.play("glow")
	
func _process(_delta):
	
	
	if (canheal and (hero.position.x < position.x + range_x and hero.position.x > position.x - range_x) and
	(hero.position.y > position.y - range_y and hero.position.y < position.y + range_y)):
		$Timer.start()
		canheal = false

func _on_Timer_timeout():
	emit_signal("near_basin")
	if global.hero_hp > 0:
		var hpvalue = pickup.instance()
		hero.add_child(hpvalue)
		hpvalue.global_position = hero.global_position
		canheal = true