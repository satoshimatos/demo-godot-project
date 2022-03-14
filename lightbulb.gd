extends Area2D

signal hit_by_projectile

var hero
var hit
var hp
export var delay = 0.01

func _ready():
	$start_delay.wait_time = delay
	$start_delay.start()
	hero = get_tree().get_nodes_in_group("heroes")[0]
	hp = get_tree().get_nodes_in_group("hp")[0]
	var _unused = connect("hit_by_projectile", hero, "_got_hit_by_projectile")
	_unused = connect("hit_by_projectile", hp, "_on_enemy_hit")
	add_to_group("projectiles")


func _on_Timer_timeout():
	$electricity.play()
	$anim.play("spark")
	$particles.emitting = true
	$sprite/animation.play("spark")
	$collision.disabled = false
	yield($sprite/animation, "animation_finished")
	$sprite/animation.stop()
	$collision.disabled = true
	$particles.emitting = false
	$anim.stop()
func _on_lightbulb_body_entered(body):
	if body.is_in_group("heroes"):
		hit = true
		emit_signal("hit_by_projectile")

func _on_start_delay_timeout():
	$Timer.start()