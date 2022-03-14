extends Area2D

const GRAVITY = 4

var speed
var jump
var velocity = Vector2()
var hero
var hp
var hit
var note_size = .5

signal hit_by_projectile

func _ready():

	add_to_group("projectiles")
	hero = get_tree().get_nodes_in_group("heroes")[0]
	hp = get_tree().get_nodes_in_group("hp")[0]
	var _unused = connect("hit_by_projectile", hero, "_got_hit_by_projectile")
	_unused = connect("hit_by_projectile", hp, "_on_enemy_hit")
	randomize()
	speed = randi() % 201 - 100
	jump = randi() % 81 - 160 #range - range position
	velocity.y = jump
	if randi() % 2 == 0:
		$sprite.play("note1")
	else:
		$sprite.play("note2")
		
func _process(delta):
	note_size -= delta/10
	scale = Vector2(note_size, note_size)
	velocity.x = speed
	velocity.y += GRAVITY
	if note_size <= 0.1:
		queue_free()
	translate(velocity * delta)

func _on_musical_notes_body_entered(body):
	if body.is_in_group("heroes"):
		hit = true
		emit_signal("hit_by_projectile")
