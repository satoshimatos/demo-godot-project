extends Area2D

const dead = preload("res://Dead.tscn")
const drop = preload ("res://heart.tscn")

var global
var hero
var hp = 5
var hit = false
var hero_hp
var lockon = false

signal enemy_hit

func _ready():
	rotation_degrees = get_parent().rotation_turret
	scale = get_parent().scale_turret
	add_to_group("enemies")
	var _unused = self.connect("body_entered", self, "_body_entered")
	hero = get_tree().get_nodes_in_group("heroes")[0]
	hero_hp = get_tree().get_nodes_in_group("hp")[0]
	_unused = self.connect("enemy_hit", hero, "_on_enemy_hit")
	_unused = self.connect("enemy_hit", hero_hp, "_on_enemy_hit")
	global = get_node("/root/Global")
func _process(_delta):
	$"../enemy_hp_bar/progress".value = hp*3

	if hp > 0:
		if $gun/aim.is_colliding():
			$alert.play()
			$reticule/anim.play("reticule")
			$reticule.visible = true
			$reticule.global_position = hero.global_position
			$gun/anim.stop()
			$gun.look_at(hero.global_position)
			$collision.look_at(hero.global_position)
			if lockon == false:
				lockon = true
				$shot/acquiringtarget.start()
		else:
			$alert.stop()
			$shooting.playing = false
			$shot.stop()
			$gun/shot3/shot_spark/anim.stop()
			$gun/shot3.visible = false
			$reticule/anim.stop()
			$reticule.visible = false
			$gun/anim.play("rotation")
			lockon = false
	
	else: #hp = 0
		var heart = drop.instance()
		var enemydeath = dead.instance()
		enemydeath.global_position = global_position
		get_node("../..").add_child(enemydeath)
		randomize()
		if randi() % 10 == 1:
			heart.position = position
			get_node("../../../collectibles").add_child(heart)
		
		get_parent().queue_free()
		
func _body_entered(body):
	if body.is_in_group("heroes"):
		hit = true
		emit_signal("enemy_hit")

func _on_shot_timeout():
	if $gun/aim.is_colliding():
		if global.hero_hp > 0:
			$shooting.play()
			$gun/shot3/shot_spark/anim.play("lighting")
			$gun/shot3.visible = true
			if hero.get_collision_mask_bit(0) == true:
				$sparks.global_position = hero.global_position
				$sparks.emitting = true
				hit = true
				emit_signal("enemy_hit")

func _on_acquiringtarget_timeout():
	lockon = false
	$shot.start()
