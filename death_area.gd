extends Area2D

var hero
var hp
var dead = false
var global
func _ready():
	global = get_node("/root/Global")
	hero = get_tree().get_nodes_in_group("heroes")[0]
	
func _process(_delta):
	if dead and global.hero_hp > 0:
		global.hero_hp -= 1

func _on_death_body_entered(body):
	hp = get_tree().get_nodes_in_group("hp")[0]
	if body.is_in_group("heroes"):
		hero.velocity.x = 0
		hero.controls = false
		dead = true