extends Area2D

const SPEED = 350

var velocity = Vector2()
var hp
var hit = false
var hero
var note_size = 1.5
var target
var shrink = true
var once = true
var boss

signal hit_by_projectile

func _ready():
	boss = get_tree().get_nodes_in_group("boss")[0]
	randomize()

	hero = get_tree().get_nodes_in_group("heroes")[0]
	hp = get_tree().get_nodes_in_group("hp")[0]
	add_to_group("projectiles")
	target = hero.position

	var _unused = connect("hit_by_projectile", hero, "_got_hit_by_projectile")
	_unused = connect("hit_by_projectile", hp, "_on_enemy_hit")
	if randi() % 2 == 0:
		$sprite.play("note1")
	else:
		$sprite.play("note2")

func _process(delta):
	if position != target:
		velocity = (target - position).normalized() * SPEED
		scale = Vector2(note_size, note_size)
		translate(velocity * delta)
	if shrink:
		note_size -= delta
	if boss.hp <= 40:
		if note_size <= 0.75:
			shrink = false
			_explode()
	else:
		if note_size <= 0.5:
			shrink = false
			_explode()

func _on_musical_notes_body_entered(body):
	if body.is_in_group("heroes"):
		hit = true
		emit_signal("hit_by_projectile")

func _explode():
	if once:
		$explosion.play()
		once = false
	$sprite.play("ripple")
	$sprite/anim.play("explode")
	yield($sprite/anim, "animation_finished")
	queue_free()