extends Area2D

export var velocity = Vector2()
var screenx
var screeny
var hero
var pencilpos
var herodir
var flipping
var boss_hp

var splash = preload ("res://impact.tscn")

func _ready():

	look_at(get_global_mouse_position())
	if flipping:
		velocity = velocity.rotated(rotation+PI)
	else:
		velocity = velocity.rotated(rotation)
	var _unused = self.connect("area_entered", self, "_area_entered")
	var screen = get_tree().get_nodes_in_group("heroes")[0].get_viewport_rect()
	hero = get_tree().get_nodes_in_group("heroes")[0]
	boss_hp = get_tree().get_nodes_in_group("boss_hp")[0]
	screenx = screen.size.x
	screeny = screen.size.y
	pencilpos = get_parent().position
	herodir = hero.get_node("animation").flip_h
	hero.shots += 2
func _process(delta):
	hero.charging -= delta*1.5
	if herodir:
		translate(-velocity * delta)

	else:
		translate(velocity * delta)
		
	if $collision/floor_collision.is_colliding():
		var impact = splash.instance()
		impact.position = position
		get_parent().add_child(impact)
		impact.get_node("sprite").scale = Vector2(1, 1)

		queue_free()

func _area_entered(body):
	if "enemies" in body.get_groups():
		body.hp -= 3
		body.get_node("anim").play("hit")


		
	if "enemies_armor" in body.get_groups():
		if (body.scale == Vector2(-1, 1) and hero.global_position.x < body.global_position.x) or (body.scale == Vector2(1, 1) and hero.global_position.x > body.global_position.x) :
			body.hp -= 3
			body.get_node("anim").play("hit")
		else:
			body.get_node("anim").play("block")
			body.get_node("no_damage").play()

		
	if "boss" in body.get_groups():
		body.hp -= 3
		boss_hp.get_node("anim").play("hit")
		body.get_node("guitar/hit").play("hit")


func _on_visibility_screen_exited():
	queue_free()
