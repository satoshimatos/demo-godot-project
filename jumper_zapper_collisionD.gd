extends Area2D

var hero
var hp
var hit = false
signal enemy_hit

func _ready():
	hp = 3
	add_to_group("enemies")
	var _unused = self.connect("enemy_hit", get_tree().get_nodes_in_group("hp")[0], "_on_enemy_hit")
	_unused = self.connect("enemy_hit", get_tree().get_nodes_in_group("heroes")[0], "_on_enemy_hit")
	_unused = self.connect("body_entered", self, "_hit")
	hero = get_tree().get_nodes_in_group("heroes")[0]


func _hit(body):
	if body.is_in_group("heroes"):
		hit = true
		emit_signal("enemy_hit")